//
//  DataModel.swift
//  Designs4U
//
//  Created by Yoli on 28/01/2023.
// He says this is like a ViewModel but didn't name it such since it furnishes multiple views - it's basically our VM

import SwiftUI


@MainActor
class DataModel: ObservableObject{
    @Published var people = [Person]()

    @Published var searchText = ""

    @Published var tokens = [Skill]()

    private var allSkills = [Skill]()
    //we upgrade this to not only show search results but also tokens = don't show Jaimie if they've asked for autocad skills.
    var searchResults: [Person] {
        //the tokens array has to be an array (maybe because it's @Published?) but we can turn it into a set here. We do it so we can get the functionality () from set used justinside the closure of filter *
        let setTokens = Set(tokens)
        //we had to add return once we'd added the above, maybe this is because the above is considered a getter and we now need to give a setter?
        return people.filter { person in
            //*
            //again, remember that if the expression on guard returns true the braces are not executed. In this case, if their skills are not in the setTokens don't include them in the new filter array.
            guard person.skills.isSuperset(of: setTokens) else { return false }
            //I'll try a different explanation since my brain won't do this one. if there is some text in the box  searchText.isEmpty == false would compute to wiould be true and it would skip the braces.
            guard searchText.isEmpty == false else { return true }
            
            for string in [person.firstName, person.lastName, person.bio, person.details] {
                if string.localizedCaseInsensitiveContains(searchText) {
                    return true
                }
            }
            return false
        }
    }
    //we also have to tell our model what to suggest to SwiftUI. Not as simple as just suggesting all the Skills all the time. Instead we'll say if our search text starts with a hash symbol, we'll use that for skills, otherwise do not. Swiftui wants these things to be sent back as a binding, since this will be using a fixed set of skills we'll not bother with that other than to satisfy it and wrap it in a binding quietly. I think .constant is from the binding bit, yes - look in bookmanrks, used for bindings that don't change.
    var suggestedTokens: Binding<[Skill]> {
        if searchText.starts(with: "#") {
            //this returns a constant Binding of allSkills on this computed property.
            return .constant(allSkills)
        } else {
            return .constant([])
        }
            
    }
    
    func fetch() async throws {
        let url = URL(string: "https://hws.dev/designers.json")!

        let (data, _) = try await URLSession.shared.data(from: url)
        people = try JSONDecoder().decode([Person].self, from: data)
        allSkills = Set(people.map(\.skills).joined()).sorted()
    }
}
