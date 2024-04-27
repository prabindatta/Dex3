//
//  SamplePokemon.swift
//  Dex3
//
//  Created by Apple on 23/04/24.
//

import Foundation
import CoreData

struct SamplePokemon {
    static let samplePokemon = {
        let context = PersistenceController.preview.container.viewContext
        
        let fetcRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetcRequest.fetchLimit = 1
        
        let results = try! context.fetch(fetcRequest)
        
        return results.first!
    }()
}
