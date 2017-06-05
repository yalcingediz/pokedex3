//
//  Pokemon.swift
//  pokedex3
//
//  Created by Berkant Y. GEDIZ on 5/31/17,22.
//  Copyright © 2017 Mnemosyne C2. All rights reserved.
//

import Foundation
import Alamofire


class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _baseAttack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!

    private var _pokemonURL: String!
    
    var name: String {
        return self._name ?? ""
    }
    
    var pokedexId: Int {
        return self._pokedexId ?? -1
    }
    
    var description: String {
        return self._description ?? ""
    }

    var nextEvolutionTxt: String {
        return self._nextEvolutionTxt ?? ""
    }
    
    var nextEvolutionName: String {
        return self._nextEvolutionName ?? ""
    }
    
    var nextEvolutionId: String {
        return self._nextEvolutionId ?? ""
    }
    
    var nextEvolutionLevel: String {
        return self._nextEvolutionLevel ?? ""
    }
    
    var baseAttack: String {
        return self._baseAttack ?? ""
    }
    
    var weight: String {
        return self._weight ?? ""
    }
    
    var height: String {
        return self._height ?? ""
    }
    
    var defense: String {
        return self._defense ?? ""
    }
    
    var type: String {
        return self._type ?? ""
    }
    
    
    init (name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(POKEMON_URL)\(self._pokedexId!)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        Alamofire.request(self._pokemonURL).validate().responseJSON { response in
            print(response.result.value!)
            if let pokeDict = response.result.value as? DictionaryofStringToAnyobject {
                if let defense = pokeDict[KEY_DEFENSE] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let attack = pokeDict[KEY_ATTACK] as? Int {
                    self._baseAttack = "\(attack)"
                }
                
                if let height = pokeDict[KEY_HEIGHT] as? String {
                    self._height = height
                }
                
                if let weight = pokeDict[KEY_WEIGHT] as? String {
                    self._weight = weight
                }
                
                if let types = pokeDict[KEY_TYPES] as? ArrayOfDictionariesOfStringToString {
                    for type in types {
                        print(type)
                        let name = type[KEY_TYPE_NAME]
                        if self._type == nil {
                            self._type = name?.capitalized
                        } else {
                            self._type! += "\(KEY_TYPE_NAME_SEPERATOR)\(name!.capitalized)"
                        }
                    }
                } else { // no types exist in JSON
                    self._type = ""
                }
                
                if let descriptionsList = pokeDict[KEY_DESCRIPTIONS] as? ArrayOfDictionariesOfStringToString, descriptionsList.count > 0 {
                    // we will look at only the first entry.
                    self.downloadPokemonDescriptions(descriptionsList: descriptionsList) {
                       print("Descriptions Download Complete !!!!!!!!")
                    }
                } else { // no descriptions exist in JSON
                    self._description = ""
                }
                
                if let evolutionsList = pokeDict[KEY_EVOLUTIONS] as? ArrayOfDictionariesOfStringToAnyobject, evolutionsList.count > 0 {
                    // we will look at only the first entry.
                    self.getPokemonEvolutions(evolutionsList: evolutionsList)
                    //print("Evolutions Download Complete !!!!!!!!")
                } else { // no descriptions exist in JSON
                    self._description = ""
                }

            }
            print("Pokemon:downloadPokemonDetails:\tname:\(self.name)\tpokedexId:\(self.pokedexId)\tdefense:\(self.defense)\tattack:\(self.baseAttack)\theight:\(self.height)\tweight\(self.weight)")
            completed()
        }
 
    }
    
    func downloadPokemonDescriptions(descriptionsList: ArrayOfDictionariesOfStringToString, completed: @escaping DownloadComplete) {
        if let strURL = descriptionsList[0][KEY_DESCRIPTION_RESOURCE_URI] {
            let fullURL = URL(string: URL_BASE+strURL)
            Alamofire.request(fullURL!).responseJSON { (response) in
              //  print("Pokemon:downloadPokemonDescriptions: \(response.result.value!)")
                if let descrList = response.result.value as? DictionaryofStringToAnyobject {
                    if let description = descrList[KEY_DESCRIPTIONS_DESCRIPTION] as? String {
                        self._description = description
                    } else {
                        self._description = "Not Available"
                    }
                }
                completed()
            }
        }
    }
    
    func getPokemonEvolutions(evolutionsList: ArrayOfDictionariesOfStringToAnyobject) {
        if let nextEvo = evolutionsList[0]["to"] as? String {  // we will look at only the first entry and not mega characters.
            if nextEvo.range(of: "mega") == nil {
                self._nextEvolutionName = nextEvo
                if let uri = evolutionsList[0]["resource_uri"] as? String {
                    let newStr = uri.replacingOccurrences(of: POKEMON_URL, with: "")
                    self._nextEvolutionId = newStr.replacingOccurrences(of: "/", with: "")
                    if let nextEvoLevel = evolutionsList[0]["level"] as? Int {
                        self._nextEvolutionLevel = "\(nextEvoLevel)"
                    } else  {
                        self._nextEvolutionLevel = ""
                    }
                }
            }
        }
        print(self.nextEvolutionLevel)
        print(self.nextEvolutionName)
        print(self.nextEvolutionId)
    }


    
    func xdescription() -> String {
        return "name:\(self._name!)\tpokedexId:\(self._pokedexId!)\tURL:\(self._pokemonURL!)"
    }
    
    
    
    
}
