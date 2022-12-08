import Foundation

class TranslationViewModel: ObservableObject {
    private let sourceLanguage = Language(id: "en", name: "English")

    @Published var languages: [Language] = []
    @Published var translatedText: String = ""
}
