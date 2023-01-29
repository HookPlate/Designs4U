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
    //an array of skills they've asked to see
    @Published var tokens = [Skill]()
    //what are all the skills they can choose from? This one won't change dynamically, unlike the above.
    private var allSkills = [Skill]()

    var searchResults: [Person] {
        return people.filter { person in
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
        //1. this saves us typing all the skills manually into our allSkills array
        //2. people.map - give us all the people mapped into an array containing the sets of skills <photoshop, Illtustrator>, <cartoonist, artist> at this point plenty of duplicates
        //3. .joined - converts the array of sets into a single array of information
        //4. Set() - putting that through a Set() to remove duplicates
        //5. .sorted() sort the result
        allSkills = Set(people.map(\.skills).joined()).sorted()
    }
}
