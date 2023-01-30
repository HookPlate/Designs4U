//
//  DesignerRow.swift
//  Designs4U
//
//  Created by Yoli on 29/01/2023.

import SwiftUI

struct DesignerRow: View {
    var person: Person
    @ObservedObject var model: DataModel
    //this is the namespace passed in from the ContentView. It doesn't use the @NameSpace property wrapper, that creates a new namespace. This says, give me a current identifier for a namespace rather than making a new one.
    var namespace: Namespace.ID
    
    var body: some View {
        HStack {
            Button {
                //where we want to select the designer, we'll not let them select more than 5
                guard model.selected.count < 5 else { return }
                // if you look back at DataModel, when we add a person to selected it'll exclude them from the search results, so we need a seperate place to add them to the search results.
                withAnimation {
                    model.select(person)
                }
            } label: {
                HStack {
                    AsyncImage(url: person.thumbnail, scale: 3)
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    //it's very common to see examples of matched geometry inside a single view, when it's between different views it more complex. This won't compile becasue initally it needs that namespace that's in the other view. The solution is to pass the view the same namespace with the namespace property at the top.
                        .matchedGeometryEffect(id: person.id, in: namespace)
                    VStack(alignment: .leading) {
                        Text(person.displayName)
                            .font(.headline)
                        
                        Text(person.bio)
                            .multilineTextAlignment(.leading)
                            .font(.caption)
                    }
                }
            }
            .tint(.primary)
            
            Spacer()
            
            Button {
                //show details
            } label: {
                Image(systemName: "info.circle")
            }
            .buttonStyle(.borderless)
        }
    }
}

struct DesignerRow_Previews: PreviewProvider {
    //satisfies the preview by making a fresh NameSpace
    @Namespace static var namespcae
    static var previews: some View {
        DesignerRow(person: .example, model: DataModel(), namespace: namespcae)
    }
}
