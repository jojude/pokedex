//
//  PokemonDetailVC.swift
//  pokedex3
//
//  Created by Jude Joseph on 10/25/16.
//  Copyright © 2016 Jude Joseph. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pokemon: Pokemon!
    
    @IBOutlet weak var segementController: UISegmentedControl!
    @IBOutlet weak var pokemonMovesTableView: UITableView!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var currentEvoImag: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var evoInfoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "\(pokemon.pokedexId)")
        
        nameLbl.text = pokemon.name.capitalized
        pokemonImage.image = image
        currentEvoImag.image = image
        pokedexLbl.text = "\(pokemon.pokedexId)"
        
        pokemonMovesTableView.delegate = self
        pokemonMovesTableView.dataSource = self
        pokemonMovesTableView.isHidden = true
        pokemonMovesTableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0)
        
        pokemon.downloadPokemonDetails {
            //only called after network call is complete
            self.updateUI()
            //self.pokemonMovesTableView.reloadData()
        }

    }
    
    func updateUI(){
        
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        if pokemon.nextEvoName == ""{
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        }else{
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: "\(pokemon.nextEvoId)")
            if pokemon.evoMethod{
                let str = "Next Evoltion : \(pokemon.nextEvoName) - Method \(pokemon.nexEvoLvl)"
                evoLbl.text = str
            }else{
                let str = "Next Evolution : \(pokemon.nextEvoName) - LVL \(pokemon.nexEvoLvl)"
                evoLbl.text = str
            }
        }
    }
    
    func hidePokeBio(){
        typeLbl.isHidden = true
        defenseLbl.isHidden = true
        heightLbl.isHidden = true
        weightLbl.isHidden = true
        attackLbl.isHidden = true
        pokedexLbl.isHidden = true
        descriptionLbl.isHidden = true
        evoLbl.isHidden = true
        evoInfoView.isHidden = true
        
    }
    
    func showPokeBio(){
        typeLbl.isHidden = false
        defenseLbl.isHidden = false
        heightLbl.isHidden = false
        weightLbl.isHidden = false
        attackLbl.isHidden = false
        pokedexLbl.isHidden = false
        descriptionLbl.isHidden = false
        evoLbl.isHidden = false
        evoInfoView.isHidden = false
        
    }

    
    @IBAction func movesPressed(_ sender: Any) {
        
        if segementController.selectedSegmentIndex == 1{
            hidePokeBio()
            self.pokemonMovesTableView.reloadData()
            pokemonMovesTableView.isHidden = false
        }else if segementController.selectedSegmentIndex == 0{
            showPokeBio()
            pokemonMovesTableView.isHidden = true
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*Build table of moves for pokemon based on level up
    only appears if moves from segment controller is selected*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.moveNames.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PokemonMoveCell = tableView.dequeueReusableCell(withIdentifier: "MoveCell", for: indexPath) as! PokemonMoveCell
        
        cell.moveNameLbl.text = pokemon.moveNames[indexPath.row]
        cell.lvlLearnedLbl.text = pokemon.moveLvl[indexPath.row]
        cell.accuracyLbl.text = pokemon.moveAccuracy[indexPath.row]
        cell.descriptionLbl.text = pokemon.moveDescription[indexPath.row]
        cell.powerLbl.text = pokemon.movePower[indexPath.row]
        cell.ppLbl.text = pokemon.movePP[indexPath.row]
        
        return cell
    }
    
    
    
}
