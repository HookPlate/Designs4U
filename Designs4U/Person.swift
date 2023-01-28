//
//  Person.swift
//  Designs4U
//
//  Created by Yoli on 28/01/2023.
//

import Foundation
//holds one person and the skills attached to them
//In order for the comparable conformance to work we need to tell it how to compare two people, see bottom <
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
    
    //for the names you could do something simple like the below but it would cause problems in many countries:
//    var displayName: String {
//            "\(firstName) \(lastname)"
//    }
    //A better idea is to let Foundation solve it for you since it has built in formatters for the names of people
    var displayName: String {
        let components = PersonNameComponents(givenName: firstName, familyName: lastName)
        //asks Foundation to format that as a String for us.
        return components.formatted()
    }
    
    //when we want to so a less than operation (comnparing 2 people) this is how to do it Swift:
    static func <(lhs: Person, rhs: Person) -> Bool {
        //sort based on the lastname of the Person
        lhs.lastName < rhs.lastName
    }
    
    //adds an example property for previewing
    static let example = Person(id: 1, photo: URL(string: "https://hws.dev/img/user-1-full.jpg")!, thumbnail: URL(string: "https://hws.dev/img/user-1-thumb.jpg")!, firstName: "Jaime", lastName: "Rove", email: "jrove1@huffingtonpost.com", experience: 10, rate: 300, bio: "A few lines about this person go here.", details: "A couple more sentences about this person go here.", skills: [Skill("Illustrator"), Skill("Photoshop")], tags: ["ideator", "aligned", "manager", "excitable"])
    
    //custom struct that conforms to Identifiable - otherwose just wrapping a String, we make it Hashable since we're using a Set to store these things that requires Hashable
    struct Skill: Comparable, Decodable, Hashable, Identifiable {
        var id: String
        
        init(_ id: String) {
            self.id = id
        }
        
        //this is a different init that handles a custom Codable conversion, required to get our String into Skill objects. As soon as you add a custom init like this to your Struct you loose the built in memberwise init, hence the init above.
//        enum CodingKeys: CodingKey {
//            case id
//        }
        
        init(from decoder: Decoder) throws {
            //there's no big object, it's just a single value
            let container = try decoder.singleValueContainer()
            //the whole thing itself is a String, decode it and store it in id
            self.id = try container.decode(String.self)
            
            
        }
        
        
        //agian we need the custom comparing < function to satisfy Comparable
        static func <(lhs: Skill, rhs: Skill) -> Bool {
            lhs.id < rhs.id
        }
    }
    
}
