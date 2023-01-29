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
            guard person.skills.isSuperset(of: setTokens) else { return true }
            guard searchText.isEmpty == false else { return true }
            
            for string in [person.firstName, person.lastName, person.bio, person.details] {
                if string.localizedCaseInsensitiveContains(searchText) {
                    return true
                }
            }
            return false
        }
    }
    
    func fetch() async throws {
        let url = URL(string: "https://hws.dev/designers.json")!

        let (data, _) = try await URLSession.shared.data(from: url)
        people = try JSONDecoder().decode([Person].self, from: data)
        allSkills = Set(people.map(\.skills).joined()).sorted()
    }
}
