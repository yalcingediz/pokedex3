//
//  ViewController.swift
//  pokedex3
//
//  Created by Berkant Y. GEDIZ on 5/31/17,22.
//  Copyright © 2017 Mnemosyne C2. All rights reserved.
//

import UIKit
import AVFoundation

class PokemonVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    var pokemonList = [Pokemon]()
    var filteredPokemonList = [Pokemon]()
    var inSearchMode = false
    
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()
        
    }
    
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 // -1: Continuous play
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
        
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            //var i = 1
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let pokeName = row["identifier"]!
                pokemonList.append(Pokemon(name: pokeName, pokedexId: pokeId))
                
                //print("\(i) - \(row)")
                //i += 1
            }
            
        } catch let err as NSError {
            print("\(err)")
        }
    }
    
    // from UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let pkmonToDisplay: Pokemon!
            if inSearchMode {
                pkmonToDisplay = filteredPokemonList[indexPath.row]
                cell.configureCell(pkmonToDisplay)
            } else {
                pkmonToDisplay = pokemonList[indexPath.row]
                cell.configureCell(pkmonToDisplay)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    // from UICollectionViewDataSource
    // how many sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // from UICollectionViewDataSource
    // how many items in collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemonList.count
        }
        return pokemonList.count
    }
    
    // from UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemonList[indexPath.row]
        } else {
            poke = pokemonList[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
    }
    
    // from UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 106, height: 107)
    }
    
    // from UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" { // not in search mode
            inSearchMode = false
            collectionView.reloadData()
            
        } else { // in search mode
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            filteredPokemonList = pokemonList.filter({$0.name.range(of: lower) != nil})
            collectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.5
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                   detailsVC.pokemon = poke
                    print("PokemonVC:prepare: \(poke.xdescription())" )
                }
            }
        }
    }

}

