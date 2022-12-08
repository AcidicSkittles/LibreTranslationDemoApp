import Foundation
import SwiftUI

class TranslationViewModel: ObservableObject {
    static let sourceLanguage = Language(id: "en", name: "English")

    @Published var languages: [Language] = []
    @Published var translatedText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showErrorAlert: Bool = false
    
    init() {
        self.fetchSupportedLanguages()
    }
    
    private func fetchSupportedLanguages() {
        isLoading = true
        LibreDataService.shared.fetchListSupportedLanguages { (result) in
            self.isLoading = false
            
            switch result {
                case .success(let languages):
                    self.languages = languages
                
                case .failure(let error):
                    self.showAlertError(error.localizedDescription)
            }
        }
    }
    
    func translate(text: String, targetLanguage: Language) {
        translatedText = ""
        guard text.count > 0 else { return }
        
        isLoading = true
        LibreDataService.shared.translate(text: text, sourceLanguage: Self.sourceLanguage, targetLanguage: targetLanguage) { (result) in
            self.isLoading = false
            
            switch result {
                case .success(let translation):
                    self.translatedText = translation.translatedText
                
                case .failure(let error):
                    self.showAlertError(error.localizedDescription)
            }
        }
    }
    
    func showAlertError(_ text: String) {
        errorMessage = text
        showErrorAlert = true
    }
    
    func hideErrorAlert() {
        errorMessage = ""
        showErrorAlert = false
    }
}
