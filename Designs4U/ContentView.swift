//
//  ContentView.swift
//  Designs4U
//
//  Created by Yoli on 28/01/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = DataModel()

    @State private var selectedDesigner: Person?
    
    @Namespace var nameSpace
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(model.searchResults) { person in
                        DesignerRow(person: person, selectedDesigner: $selectedDesigner, model: model, namespace: nameSpace)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Designs4u")
            .searchable(text: $model.searchText, tokens: $model.tokens, suggestedTokens: model.suggestedTokens, prompt: Text("Search, or use # to select skills")) { token in
                Text(token.id)
            }
            .sheet(item: $selectedDesigner, content: DesignerDetails.init)
            .safeAreaInset(edge: .bottom) {
                if model.selected.isEmpty == false {
                    VStack {
                        HStack(spacing: -10) {
                            ForEach(model.selected) { person in
                                Button {
                                    //this is what does the animation for MatchedGeometryEffect
                                    withAnimation {
                                        model.remove(person)
                                    }
                                } label: {
                                    AsyncImage(url: person.thumbnail, scale: 3)
                                        .frame(width: 60, height: 60)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.white, lineWidth: 2)
                                        )
                                }
                                .buttonStyle(.plain)
                                .matchedGeometryEffect(id: person.id, in: nameSpace)
                            }
                        }
                        NavigationLink {
                            //Go to the next screen
                        } label: {
                            Text("Select ^[\(model.selected.count) Person](inflect: true)")
                                .frame(maxWidth: .infinity, minHeight: 44)
                        }
                        .buttonStyle(.borderedProminent)
                        .contentTransition(.identity)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.horizontal, .top])
                    .background(.ultraThinMaterial)
                    
                }
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
