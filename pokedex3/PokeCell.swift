//
//  PokeCell.swift
//  pokedex3
//
//  Created by Jude Joseph on 10/25/16.
//  Copyright © 2016 Jude Joseph. All rights reserved.
//

import UIKit
import pop

class PokeCell: UICollectionViewCell {
    
    //modify image and label in cell
    @IBOutlet weak var thumbImag: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    //create class of pokemon for each cell
    var pokemon: Pokemon!
    
    //call when we are ready to update content of each cell
    func configureCell(_ pokemon: Pokemon){
        
        self.pokemon = pokemon
        
        nameLbl.text = pokemon.name.capitalized
        thumbImag.image = UIImage(named: "\(pokemon.pokedexId)")
        
    }
    
    //UI 
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        //each view has a layer level to modify how it looks
        layer.cornerRadius = 5.0
        
    }
    
    func scaleToSmall(){
        //scale animation we want to run to a certain value
        let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim?.toValue = NSValue(cgSize: CGSize(width: 0.90, height: 0.90))
        self.layer.pop_add(scaleAnim, forKey: "layerScaleSmallAnimation")
    }
    
    func scaleAnimation(){
        //spring animation
        let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim?.velocity = NSValue(cgSize: CGSize(width: 3.0, height: 3.0))
        scaleAnim?.toValue = NSValue(cgSize: CGSize(width: 1.0, height: 1.0))
        scaleAnim?.springBounciness = 18
        self.layer.pop_add(scaleAnim, forKey: "layerScaleSpringAnimation")
    }
    
    func scaleDefault(){
        let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim?.toValue = NSValue(cgSize:CGSize(width: 1, height: 1))
        self.layer.pop_add(scaleAnim, forKey: "layerScaleDefaultAnimation")
    }
}
