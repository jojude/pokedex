//
//  PokemonDetailVC.swift
//  pokedex3
//
//  Created by Jude Joseph on 10/25/16.
//  Copyright © 2016 Jude Joseph. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "\(pokemon.pokedexId)")
        
        nameLbl.text = pokemon.name.capitalized
        pokemonImage.image = image
        currentEvoImag.image = image
        pokedexLbl.text = "\(pokemon.pokedexId)"
        
        pokemon.downloadPokemonDetails {
            //only called after network call is complete
            self.updateUI()
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

    @IBAction func backButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
