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
                    //use only the ones who ,m,atch our search text.
                    ForEach(model.searchResults) { person in
                        DesignerRow(person: person, model: model)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Designs4u")
            //we get basic searching up and running by adding a single modifier to our model, this gives us the search bar below the nav title.
            .searchable(text: $model.searchText)
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
