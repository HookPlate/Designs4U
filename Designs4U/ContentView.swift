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
                    ForEach(model.people) { person in
                        //passes both the person and model into our cutom row
                        DesignerRow(person: person, model: model)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Designs4u")
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
