//
//  Constants.swift
//  pokedex3
//
//  Created by Berkant Y. GEDIZ on 6/3/17,22.
//  Copyright © 2017 Mnemosyne C2. All rights reserved.
//

import Foundation

let URL_BASE = "http://pokeapi.co"
let POKEMON_URL = "/api/v1/pokemon/"

let KEY_ATTACK = "attack"
let KEY_DEFENSE = "defense"
let KEY_DESCRIPTIONS = "descriptions"
let KEY_EVOLUTIONS = "evolutions"
let KEY_HEIGHT = "height"
let KEY_WEIGHT = "weight"
let KEY_TYPES = "types"
let KEY_TYPE_NAME = "name"
let KEY_TYPE_NAME_SEPERATOR = "/"
let KEY_DESCRIPTION_NAME = "name"
let KEY_DESCRIPTION_RESOURCE_URI = "resource_uri"
let KEY_DESCRIPTIONS_DESCRIPTION = "description"

typealias DownloadComplete = () -> ()
typealias DictionaryOfStringToString = Dictionary<String, String>
typealias ArrayOfDictionariesOfStringToString = [Dictionary<String, String>]
typealias DictionaryofStringToAnyobject = Dictionary<String, AnyObject>
typealias ArrayOfDictionariesOfStringToAnyobject = [Dictionary<String, AnyObject>]
