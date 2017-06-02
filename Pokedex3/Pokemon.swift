//
//  Pokemon.swift
//  Pokedex3
//
//  Created by Arturo on 2017-05-29.
//  Copyright © 2017 Arturo Arena. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type : String!
    private var _defense : Int!
    private var _height : String!
    private var _weight : String!
    private var _attack : Int!
    private var _nextEvolution : String!
    private var _nextEvolutionId: String!
    private var _pokemonURL: String!
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var pokedexId: Int {
        if _pokedexId == nil {
            _pokedexId = 0
        }
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: Int {
        if _defense == nil {
            _defense = 0
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: Int {
        if _attack == nil {
            _attack = 0
        }
        return _attack
    }
    
    var nextEvolution: String {
        if _nextEvolution == nil {
            _nextEvolution = ""
        }
        return _nextEvolution
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: @escaping () -> ()) {
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            if let dict = response.result.value as? [String:AnyObject]{
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = attack
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = defense
                }
                if let types = dict["types"] as? [[String:String]] {
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    if types.count > 1 {
                        for i in 1..<types.count {
                            if let name = types[i]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                }
                if let descriptions = dict["descriptions"] as? [[String:String]] {
                    if let url = descriptions[0]["resource_uri"] {
                        let completeUrl = "\(URL_BASE)\(url)"
                        Alamofire.request(completeUrl).responseJSON(completionHandler: { (response) in
                            if let dict2 = response.result.value as? [String:AnyObject] {
                                if let desc = dict2["description"] as? String {
                                    let newDesc = desc.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDesc
                                }
                            }
                            completed()
                        })
                    }
                }
                if let evolutions = dict["evolutions"] as? [[String:AnyObject]], evolutions.count > 0 {
                    var level = ""
                    var method = ""
                    var name = ""
                    if let _Id = evolutions[0]["resource_uri"] as? String {
                        let Id = _Id.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                        self._nextEvolutionId = Id.replacingOccurrences(of: "/", with: "")
                    }
                    if let _name = evolutions[0]["to"] as? String {
                        name = _name
                    }
                    if let _meth = evolutions[0]["method"] as? String {
                        method = _meth
                        if _meth == "level_up" {
                            if let _level = evolutions[0]["level"] as? Int {
                                level = "\(_level)"
                            }
                            self._nextEvolution = "Next Evolution: \(name) - LVL \(level)"
                        } else if _meth == "other"{
                            if let detail = evolutions[0]["detail"] as? String {
                                if detail == "mega" {
                                    self._nextEvolutionId = ""
                                    self._nextEvolution = "Mega Evolution to \(name)"
                                } else {
                                    self._nextEvolutionId = ""
                                    self._nextEvolution = "May Evolve By \(detail)"
                                }
                            }
                            
                        } else {
                            self._nextEvolution = "Next Evolution: \(name) - BY \(method)"
                        }
                    }
                    
                } else {
                    self._nextEvolution = "No Evolution"
                }
                print(self._weight)
                print(self._height)
                print(self._defense)
                print(self._attack)
            }
        }
        
    }
    
    
    
}
