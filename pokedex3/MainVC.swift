//
//  ViewController.swift
//  pokedex3
//
//  Created by Jude Joseph on 10/25/16.
//  Copyright © 2016 Jude Joseph. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    var inside = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()
        
    }
    
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying{
            musicPlayer.pause()
            sender.alpha = 0.2
        }else{
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
    }
    

    func initAudio(){
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do{
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            //set continuous loop
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let poke: Pokemon!
        let cell = collectionView.cellForItem(at: indexPath) as? PokeCell
        cell?.scaleAnimation()
        
        if inSearchMode{
            poke = filteredPokemon[indexPath.row]
        }else{
            poke = pokemon[indexPath.row]
        }
        
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
                self.performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
            })
    }
    
    //set data to be passed between view controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PokemonDetailVC"{
            if let detailsVC = segue.destination as? PokemonDetailVC{
                if let poke = sender as? Pokemon{
                    detailsVC.pokemon = poke
                }
            }
        }
    }
    
    //create a function that parses the csv pokemon data in a way that is useful to s=us
    func parsePokemonCSV(){
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            for row in rows{
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
                
            }
        }catch let err as NSError{
                print(err.debugDescription)
            }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //loads only amount of cells displayed at a time not all of the objects at once
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
            
            //take data from pokemon cell and pass it in to view controller
            let poke: Pokemon!
            
            if inSearchMode{
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
            }else{
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
            }
            
            return cell
        } else{
            return UICollectionViewCell()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode{
            return filteredPokemon.count
        }
        
        return pokemon.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:105, height:105)
    }
    
    //search for pokemon name
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == ""{
            //revert back to array of original pokemon
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
        }else{
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            /*the filteredPokemon list is each to the original pokemon list but filter
            $0 is thought of a placeholder for any pokemon in the array
            take the name value of that and saying is what we put into the search bar
            contained in that name and if it is we put it in the pokemon list*/
            
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil })
            collection.reloadData()
            
        }
    }
}


