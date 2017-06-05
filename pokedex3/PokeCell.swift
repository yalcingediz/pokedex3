//
//  PokeCellCollectionViewCell.swift
//  pokedex3
//
//  Created by Berkant Y. GEDIZ on 6/1/17,22.
//  Copyright © 2017 Mnemosyne C2. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    
    var pokemon: Pokemon!
    
    required init?(coder aDecodder: NSCoder) {
        super.init(coder: aDecodder)
        
        layer.cornerRadius = 5.0
    }
    
    func configureCell(_ pokemon: Pokemon) {
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
}
