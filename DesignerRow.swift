//
//  DesignerRow.swift
//  Designs4U
//
//  Created by Yoli on 29/01/2023.

import SwiftUI

struct DesignerRow: View {
    var person: Person
    @ObservedObject var model: DataModel
    
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
    static var previews: some View {
        DesignerRow(person: .example, model: DataModel())
    }
}
