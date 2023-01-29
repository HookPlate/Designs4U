//
//  DesignerRow.swift
//  Designs4U
//
//  Created by Yoli on 29/01/2023.
//This will hold one row in our long list of Designers

import SwiftUI

struct DesignerRow: View {
    var person: Person
    //I expect to be given DataModel and I want to watch for changes but I don't want to actuslly create it. See comparison to @StateObject in ContentView.
    @ObservedObject var model: DataModel
    
    var body: some View {
        HStack {
            Button {
                //select thsi designer
            } label: {
                HStack {
                    //since they super retina images we only want one third on our screen so scale 3
                    AsyncImage(url: person.thumbnail, scale: 3)
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    VStack(alignment: .leading) {
                        Text(person.displayName)
                            .font(.headline)
                        
                        Text(person.bio)
                        //stick to the leading edge
                            .multilineTextAlignment(.leading)
                            .font(.caption)
                    }
                }
            }
            //by default buttons have a blue tint to them, we want just black or white
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
