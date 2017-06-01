//
//  Pokemon.swift
//  pokedex3
//
//  Created by Berkant Y. GEDIZ on 5/31/17,22.
//  Copyright © 2017 Mnemosyne C2. All rights reserved.
//

import Foundation

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    
    var name: String {
        return self._name
    }
    
    var pokedexId: Int {
        return self._pokedexId
    }
    
    init (name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
}
