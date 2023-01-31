//
//  Person.swift
//  Designs4U
//
//  Created by Yoli on 28/01/2023.
//Our Model

import Foundation

struct Person: Comparable, Decodable, Identifiable {
    var id: Int
    var photo: URL
    var thumbnail: URL
    var firstName: String
    var lastName: String
    var email: String
    var experience: Int
    var rate: Int
    var bio: String
    var details: String
    var skills: Set<Skill>
    var tags: [String]
    
    var displayName: String {
        let components = PersonNameComponents(givenName: firstName, familyName: lastName)

        return components.formatted()
    }
    

    static func <(lhs: Person, rhs: Person) -> Bool {
        lhs.lastName < rhs.lastName
    }
    
    static let example = Person(id: 1, photo: URL(string: "https://hws.dev/img/user-1-full.jpg")!, thumbnail: URL(string: "https://hws.dev/img/user-1-thumb.jpg")!, firstName: "Jaime", lastName: "Rove", email: "jrove1@huffingtonpost.com", experience: 10, rate: 300, bio: "A few lines about this person go here.", details: "A couple more sentences about this person go here.", skills: [Skill("Illustrator"), Skill("Photoshop")], tags: ["ideator", "aligned", "manager", "excitable"])
    
}

//In order to support tokens we can't us .self as an Identifier like in ForEach. We need to manually make an ID ourselves in order to support Identifiable.
struct Skill: Comparable, Decodable, Hashable, Identifiable {
    var id: String
    
    init(_ id: String) {
        self.id = id
    }
    
    
    init(from decoder: Decoder) throws {
        //Here's where we tell swift that the Struct isn't some complex object, it's just a String. Read it out from that entire String, don't try and read keys inside there using CodingKeys etc, the whole container is our String: .singleValueContainer
        let container = try decoder.singleValueContainer()
        self.id = try container.decode(String.self)
    }
    
    static func <(lhs: Skill, rhs: Skill) -> Bool {
        lhs.id < rhs.id
    }
}
