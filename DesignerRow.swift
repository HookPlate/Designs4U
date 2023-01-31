//
//  DesignerRow.swift
//  Designs4U
//
//  Created by Yoli on 29/01/2023.

import SwiftUI

struct DesignerRow: View {
    var person: Person
    
    @Binding var selectedDesigner: Person?
    
    @ObservedObject var model: DataModel
    
    var namespace: Namespace.ID
    
    var body: some View {
        HStack {
            Button {
                guard model.selected.count < 5 else { return }
                //again this animates our matchedGeometry effect.
                withAnimation {
                    model.select(person)
                }
            } label: {
                HStack {
                    AsyncImage(url: person.thumbnail, scale: 3)
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
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
                selectedDesigner = person
            } label: {
                Image(systemName: "info.circle")
            }
            .buttonStyle(.borderless)
        }
    }
}

struct DesignerRow_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        DesignerRow(person: .example, selectedDesigner: .constant(nil), model: DataModel(), namespace: namespace)
    }
}
