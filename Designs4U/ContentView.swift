//
//  ContentView.swift
//  Designs4U
//
//  Created by Yoli on 28/01/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = DataModel()
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(model.searchResults) { person in
                        DesignerRow(person: person, model: model)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Designs4u")
            //for the more advanced searchable with tokens we need to say where we are storing our tokens (tokens:), then what list we want to show to the user (suggestedTokens:), a prompt so the user knows about the # rule. Then it wants to be given a trailing closure that knows how to convert one search token into something you can show in the UI.
            .searchable(text: $model.searchText, tokens: $model.tokens, suggestedTokens: model.suggestedTokens, prompt: Text("Search, or use # to select skills")) { token in
                //this works thanks to us casting into a Skill and giving it an ID
                Text(token.id)
            }
        }
        .task {
            do {
                try await model.fetch()
                
            } catch {
                print("Error handling is great!")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
