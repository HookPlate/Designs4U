//
//  DataModel.swift
//  Designs4U
//
//  Created by Yoli on 28/01/2023.
//

import SwiftUI

//An ObservableObject class that handles manipulating data somehow for us.
//Ensures it's performed on hte main thread
@MainActor
class DataModel: ObservableObject{
    @Published var people = [Person]()
    
    func fetch() async throws {
        let url = URL(string: "https://hws.dev/designers.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        people = try JSONDecoder().decode([Person].self, from: data)
    }
}
