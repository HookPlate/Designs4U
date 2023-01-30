//
//  DesignerDetails.swift
//  Designs4U
//
//  Created by Yoli on 30/01/2023.
//

import SwiftUI
//View to show more information about that person - we show this on the screen by using the sheet modifier in content view.
struct DesignerDetails: View {
    var person: Person
    
    var body: some View {
        //it's generally a good idea to have your views in a ScrollView anyway becasue of Dynamic Type
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                //the persons photo is the bigger version, so no the thumbnail
                //cashes the image but if your app quits it clears the cache. Not something he linkes but has to live with it.
                AsyncImage(url: person.photo, scale: 3)
                //you want a border use overlay witha shape in it
                    .overlay(
                        Rectangle()
                            .strokeBorder(.primary.opacity(0.2), lineWidth: 4)
                    )
                    //we want the above to be centered on the screen so stretch out the space horizontally for it.
                    .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(person.displayName)
                        .font(.largeTitle.bold())
                    Text(person.bio)
                    Text(person.details)
                }
                //this VStack has the same setting os the last but it has padding, meaning the bio and details will have padding but not the mother VStack, see simulator.
                .padding()
            }
            .padding(.vertical)
        }
    }
}

//struct DesignerDetails_Previews: PreviewProvider {
//    static var previews: some View {
//        DesignerDetails()
//    }
//}
