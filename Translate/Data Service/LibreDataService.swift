//
//  LibreDataService.swift
//  Translate
//
//  Created by Derek Buchanan on 9/26/22.
//

import UIKit
import SwiftUI

class LibreDataService {
    static let shared: LibreDataService = LibreDataService()
    private let baseURLString: String = "https://libretranslate.de"
    
    /// Gather a list of supported languages used by Libre.
    /// - Parameter completion: Completion that returns a result of success containing a list of supported languages or a failure result containing an error with the description.
    func fetchListSupportedLanguages(completion: @escaping (Result<[Language], Error>) -> Void) {
        guard let validURL = self.url(path: "/languages") else {
            return
        }
        
        URLSession.shared.dataTask(with: validURL) { (data, response, error) in
            DispatchQueue.main.async {
                guard let validData = data, error == nil else {
                    completion(.failure(error!))
                    return
                }
                
                if let libreError = self.libreError(response: response, data: data) {
                    completion(.failure(libreError))
                    return
                }
                
                do {
                    let languages = try JSONDecoder().decode([Language].self, from: validData)
                    completion(.success(languages))
                } catch let serializationError {
                    completion(.failure(serializationError))
                }
            }
        }.resume()
    }
    
    /// Translate text into a target language.
    /// - Parameters:
    ///   - text: The input text to be translated.
    ///   - sourceLanguage: The source language that text is in.
    ///   - targetLanguage: The desired target Language to translate the input text into.
    ///   - completion: Completion that returns a result of success containing the translation or a failure result containing an error with the description.
    func translate(text: String, sourceLanguage: Language, targetLanguage: Language, completion: @escaping (Result<Translation, Error>) -> Void) {
        guard let validURL = self.url(path: "/translate") else {
            return
        }
        
        let formPayload: Dictionary = ["q" : text,
                                       "source" : sourceLanguage.id,
                                       "target" : targetLanguage.id,
                                       "format" : "text"]
        
        var postRequest = URLRequest(url: validURL)
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        postRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: formPayload, options: [])
            postRequest.httpBody = httpBody
        } catch let serializationError {
            completion(.failure(serializationError))
        }
        
        URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let validData = data, error == nil else {
                    completion(.failure(error!))
                    return
                }
                
                if let libreError = self.libreError(response: response, data: data) {
                    completion(.failure(libreError))
                    return
                }
                
                do {
                    let translatedText = try JSONDecoder().decode(Translation.self, from: validData)
                    completion(.success(translatedText))
                } catch let serializationError {
                    completion(.failure(serializationError))
                }
            }
        }.resume()
    }
    
    private func url(path: String) -> URL? {
        var baseURL = URL(string: baseURLString)
        baseURL?.appendPathComponent(path)
        
        return baseURL
    }
    
    
    /// Inspect Libre HTTP responses for API specific errors.
    /// - Parameters:
    ///   - response: The URL response.
    ///   - data: The response data
    /// - Returns: An Error containing the API error description or nil if a valid API error was not found.
    private func libreError(response: URLResponse?, data: Data?) -> Error? {
        guard let response = response as? HTTPURLResponse, let data = data else { return nil }

        if response.statusCode >= 400 {
            do {
                let libreError = try JSONDecoder().decode(LibreError.self, from: data)
                
                let error = NSError(domain: self.baseURLString, code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : libreError.error])
                return error
            } catch {
                return nil
            }
        }
        
        return nil
    }
}
