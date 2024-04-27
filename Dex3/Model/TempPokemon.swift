//
//  TempPokemon.swift
//  Dex3
//
//  Created by Apple on 23/04/24.
//

import Foundation

struct TempPokemon: Codable {
    let id: Int
    let name: String
    let types: [String]
    var hp = 0
    var attack = 0
    var defense = 0
    var specialAttach = 0
    var specialDefense = 0
    var speed = 0
    let sprite: URL
    let shiny: URL
    
    enum PokemonKeys: String, CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
        
        enum TypeDictionaryKeys: String, CodingKey {
            case type
            
            enum TypeKeys: String, CodingKey {
                case name
            }
        }
        
        enum StatDictionaryKeys: String, CodingKey {
            case value = "base_stat"
            case stat
            
            enum StatKeys: String, CodingKey {
                case name
            }
        }
        
        enum SpriteKeys: String, CodingKey {
            case sprite = "front_default"
            case shiny = "front_shiny"
        }
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        
        self.name = try container.decode(String.self, forKey: .name)
        
        var decodedTypes: [String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        while !typesContainer.isAtEnd {
            let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
            
            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        self.types = decodedTypes
        
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.self)
            let statsContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.StatKeys.self, forKey: .stat)
            
            let stat = try statsContainer.decode(String.self, forKey: .name)
            switch stat {
            case "hp":
                self.hp = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "attack":
                self.attack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "defense":
                self.defense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-attach":
                self.specialAttach = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-defense":
                self.specialDefense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "speed":
                self.speed = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            default:
                break
            }
        }
        
        let spritesContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)
        
        self.sprite = try spritesContainer.decode(URL.self, forKey: .sprite)
        self.shiny = try spritesContainer.decode(URL.self, forKey: .shiny)
    }
}
