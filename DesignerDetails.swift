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
                        //new in IOS 16 doesn't work here..fontDesign(.rounded)
                    Text(person.bio)
                    Text(person.details)
                }
                //this VStack has the same setting os the last but it has padding, meaning the bio and details will have padding but not the mother VStack, see simulator.
                .padding()
                //At the bottom of the mother VStack, indicators are the little gray lines that give the users a sense of how long the scroll content is.
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(person.tags, id: \.self) { tag in
                            Text(tag)
                                .padding(5)
                          //  extra padding horizontally so it looks better on the screen
                                .padding(.horizontal)
                            //new in IOS 16 is the .gradient color variation
                                .background(.blue.gradient)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal)
                }
                //gives a slight faded effect to one edge of the HStack showing the user that the view is scrollable
                .mask(
                    LinearGradient(stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .white, location: 0.05),
                        .init(color: .white, location: 0.95),
                        .init(color: .clear, location: 1)
                    ], startPoint: .leading, endPoint: .trailing)
                )
                //uses markdown and automatic grammar agreement (first line with year/years) ** makes something bold in markdown I suppose. .init() makes the email interactive
                VStack(alignment: .leading, spacing: 10) {
                    Text("**Experience:** ^[\(person.experience) years](inflect: true)")
                    Text("**Rate:** $\(person.rate)")
                    Text(.init("**Contact:** \(person.email)"))
                }
                .padding()
            }
            .padding(.vertical)
        }
        //allows us to present the sheet as a bottom sheet. Since we asked for medium and large there's a drag bar for the user to drag up with the sheet.
        .presentationDetents([.medium, .large])
    }
}

//struct DesignerDetails_Previews: PreviewProvider {
//    static var previews: some View {
//        DesignerDetails()
//    }
//}
