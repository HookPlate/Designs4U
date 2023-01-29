//
//  DataModel.swift
//  Designs4U
//
//  Created by Yoli on 28/01/2023.
//

import SwiftUI


@MainActor
class DataModel: ObservableObject{
    @Published var people = [Person]()
    //stores some search text typed into the screen
    @Published var searchText = ""
    //A subset of the people array based on what matches their queiry
    var searchResults: [Person] {
        people.filter { person in
            //they type nothing, this person is definately in the final array because there's no text to match on.
            guard searchText.isEmpty == false else { return true }
            //if we're still here it means they've typed some search text, which of those fields match that search text if any?
            //if any of those strings match (case insensitively) our searchText, return true.
            for string in [person.firstName, person.lastName, person.bio, person.details] {
                if string.localizedCaseInsensitiveContains(searchText) {
                    return true
                }
            }
            //if we get to here, non of them matched, do not include this person in the final results
            return false
        }
    }
    
    func fetch() async throws {
        let url = URL(string: "https://hws.dev/designers.json")!

        let (data, _) = try await URLSession.shared.data(from: url)
        people = try JSONDecoder().decode([Person].self, from: data)
    }
}
