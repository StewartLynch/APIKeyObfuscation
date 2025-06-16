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


import SwiftUI

struct ThesaurusView: View {
    @State private var manager = ThesaurusManager()
    @FocusState var isFocused: Bool
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    TextField("Enter a word then tap 'Search'", text: $manager.word)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .submitLabel(.search)
                        .focused($isFocused)
                        .onSubmit {
                            Task { await manager.search() }
                        }
                        .onChange(of: isFocused) {
                            if !isFocused && !manager.word.isEmpty {
                                Task { await manager.search() }
                            }
                        }
                    if !manager.word.isEmpty {
                        Button {
                            manager.reset()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .buttonStyle(.plain)
                    }
                }
                if let error = manager.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
                if !manager.definition.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Definition")
                            .font(.title3)
                            .bold()
                        Text(manager.definition)
                    }
                    Divider()
                    if !manager.synonyms.isEmpty {
                        Text("Synonyms:")
                            .font(.title3)
                            .bold()
                    }
                }

                if !manager.synonyms.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(manager.synonyms, id: \.self) { synonym in
                                Text("• \(synonym)")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .scrollBounceBehavior(.basedOnSize)
                }
                if manager.synonyms.isEmpty {
                    Spacer()
                }
            }
            .padding()
            .navigationTitle("Thesaurus")
            .ignoresSafeArea(edges: .bottom)
            .onAppear {
                isFocused = true
            }
        }
    }
}

#Preview {
    ThesaurusView()
}
