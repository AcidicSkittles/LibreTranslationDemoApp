import SwiftUI


struct TranslationView: View {

    @State private var selectedLanguage: Language = TranslationViewModel.sourceLanguage
    @State private var inputText: String = ""
    @StateObject private var viewModel = TranslationViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Original")) {
                        TextField("Input text to translate", text: $inputText).padding()
                    }
                    Section(header: Text("Translated")) {
                        Text(viewModel.translatedText).padding()
                    }
                    Section {
                        if viewModel.languages.count > 0 {
                            Picker("Translate to:", selection: $selectedLanguage) {
                                ForEach(viewModel.languages, id: \.self) { language in
                                    Text(language.name)
                                }
                            }
                        }
                        else {
                            Text("Loading languages...").padding()
                        }
                    }
                }.listStyle(InsetGroupedListStyle())
                
                if viewModel.isLoading {
                    ProgressView().padding()
                }
                else {
                    Button("Translate!", action: translate).padding().disabled(inputText.count == 0)
                }
            }.alert(isPresented: $viewModel.showErrorAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("Okay"), action: viewModel.hideErrorAlert))
            }
        }
    }
    
    func translate() {
        self.viewModel.translate(text: inputText, targetLanguage: selectedLanguage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TranslationView()
    }
}
