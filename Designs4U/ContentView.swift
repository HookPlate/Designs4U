//
//  ContentView.swift
//  Designs4U
//
//  Created by Yoli on 28/01/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = DataModel()
    //this declares a little pot basically, in which each view id will appear only once
    @Namespace var nameSpace
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(model.searchResults) { person in
                        DesignerRow(person: person, model: model, namespace: nameSpace)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Designs4u")
            .searchable(text: $model.searchText, tokens: $model.tokens, suggestedTokens: model.suggestedTokens, prompt: Text("Search, or use # to select skills")) { token in
                Text(token.id)
            }
            .safeAreaInset(edge: .bottom) {
                //if we have any selections sho a VStack of stuff
                if model.selected.isEmpty == false {
                    //normally he'd refactor this out but for some reason doing so creates warnings so it has to be here
                    VStack {
                        //selected Designers
                        //that spacing compresses them, overlaps them
                        HStack(spacing: -10) {
                            ForEach(model.selected) { person in
                                Button {
                                    withAnimation {
                                        //means that once they're in the bottom selected area we can still tap to remove them.
                                        model.remove(person)
                                    }
                                } label: {
                                    AsyncImage(url: person.thumbnail, scale: 3)
                                        .frame(width: 60, height: 60)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    //since we're compressing, overlapping the pictures, having a little stroke around them means they don't clash
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.white, lineWidth: 2)
                                        )
                                }
                                //means it won't animate too much on the screen
                                .buttonStyle(.plain)
                                //so inside the 'namespace' pot of names this view is id number.. we need this same modifier attached to the designerRow, the thing we're moving from
                                .matchedGeometryEffect(id: person.id, in: nameSpace)
                            }
                        }
                        //continue button which is basically a nav link for when they have some designers selected and they want to 'go' and it'll show them whatever, available date/times etc.
                        NavigationLink {
                            //Go to the next screen
                        } label: {
                            Text("Select \(model.selected.count) Person")
                            //will stretch the button across the whole screens width, the min height of 44 is a recomendation from apple
                                .frame(maxWidth: .infinity, minHeight: 44)
                        }
                        .buttonStyle(.borderedProminent)
                        //as of IOS 16 it loves animating text changing, a lovely magic move type transition, it looks crap on Buttons though so this dissables it.
                        .contentTransition(.identity)
                        
                    }
                    //edge to edge
                    .frame(maxWidth: .infinity)
                    .padding([.horizontal, .top])
                    //frosted glass so you can see the scrolling view behind it.
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
