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

struct ContentView: View {
    @State private var viewModel = ThesaurusViewModel()
    @FocusState var isFocused: Bool
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    TextField("Enter a word then tap 'Search'", text: $viewModel.word)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .submitLabel(.search)
                        .focused($isFocused)
                        .onSubmit {
                            Task { await viewModel.search() }
                        }
                        .onChange(of: isFocused) {
                            if !isFocused && !viewModel.word.isEmpty {
                                Task { await viewModel.search() }
                            }
                        }
                    if !viewModel.word.isEmpty {
                        Button {
                            viewModel.reset()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .buttonStyle(.plain)
                    }
                }
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }

                if !viewModel.definition.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Definition")
                            .font(.title3)
                            .bold()
                        Text(viewModel.definition)
                    }

                    if !viewModel.synonyms.isEmpty {
                        Text("Synonyms:")
                            .font(.title3)
                            .bold()
                    }
                }

                if !viewModel.synonyms.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(viewModel.synonyms, id: \.self) { synonym in
                                Text("• \(synonym)")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .scrollBounceBehavior(.basedOnSize)
                }
                if viewModel.synonyms.isEmpty {
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
    ContentView()
}
