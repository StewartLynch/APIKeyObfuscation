//
//----------------------------------------------
// Original project: WhatWord
// by  Stewart Lynch on 2025-06-16
//
// Follow me on Mastodon: https://iosdev.space/@StewartLynch
// Follow me on Threads: https://www.threads.net/@stewartlynch
// Follow me on Bluesky: https://bsky.app/profile/stewartlynch.bsky.social
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Email: slynch@createchsol.com
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch
//----------------------------------------------
// Copyright © 2025 CreaTECH Solutions. All rights reserved.



import Foundation

@MainActor
@Observable
class ThesaurusManager {
    var word: String = ""
    var definition: String = ""
    var synonyms: [String] = []
    var errorMessage: String?

    private let apiKey = "<<Your API Key>>"

    func search() async {
        guard !word.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let query = word.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? word
        let urlString = "https://dictionaryapi.com/api/v3/references/thesaurus/json/\(query)?key=\(apiKey)"

        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let results = try JSONDecoder().decode([Thesaurus].self, from: data)

            if let first = results.first {
                definition = first.shortdef.first ?? "No definition available."
                synonyms = first.meta.syns.first ?? []
                errorMessage = nil
            } else {
                definition = ""
                synonyms = []
                errorMessage = "No results found."
            }
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
            definition = ""
            synonyms = []
        }
    }
    
    func reset() {
        word = ""
        definition = ""
        synonyms = []
        errorMessage = nil
    }
}
