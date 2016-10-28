//
//  Pokemon.swift
//  pokedex3
//
//  Created by Jude Joseph on 10/25/16.
//  Copyright © 2016 Jude Joseph. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _evoNextEvoText: String!
    private var _nextEvoId: String!
    private var _nextEvoName: String!
    private var _nextEvoLvl: String!
    private var _evoMethod: Bool!
    private var _pokemonURL: String!
    
    
    //data protection/hiding to assure to return a real value or return nil
    var evoMethod: Bool{
        if _evoMethod == nil{
            _evoMethod = false
        }
        return _evoMethod
    }
    
    var nextEvoName: String{
        if _nextEvoName == nil{
            _nextEvoName = ""
        }
        return _nextEvoName
    }
    
    var nextEvoId: String{
        if _nextEvoId == nil{
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    var nexEvoLvl: String{
        if _nextEvoLvl == nil{
            _nextEvoLvl = ""
        }
        return _nextEvoLvl
    }
    
    var evoNextEvoText: String{
        if _evoNextEvoText == nil{
           _evoNextEvoText = ""
        }
        return _evoNextEvoText
    }
    
    var attack: String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    
    var defense: String{
        if _defense == nil{
           _defense = ""
        }
        return _defense
    }
    
    var weight: String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    
    var height: String{
        if _height == nil{
            _height = ""
        }
        return _height
    }
    
    
    var type: String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    var description: String{
        if _description == nil{
            _description = ""
        }
        return _description
    }
    
   //---------------------------
    
    var name: String{
        return _name
    }
    
    var pokedexId:Int {
        return _pokedexId
    }
    
    init(name:String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    
    //lazy loading
    func downloadPokemonDetails(completed: @escaping DownloadComplete){
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            if let dict = response.result.value as? Dictionary<String, AnyObject>{
                
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                if let height = dict["height"] as? String{
                    self._height = height
                }
                if let attack = dict["attack"] as? Int{
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int{
                    self._defense = "\(defense)"
                }
                
                if let descriptions = dict["descriptions"] as? [Dictionary<String,String>] , descriptions.count > 0{
                    if let url = descriptions[0]["resource_uri"]{
                        let descriptionURL = "\(URL_BASE)\(url)"
                        
                        Alamofire.request(descriptionURL).responseJSON { (response) in
                            if let dict = response.result.value as? Dictionary<String, AnyObject>{
                                if let descript = dict["description"] as? String{
                                    let newDescription = descript.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDescription
                                }
                            }
                            completed()
                        }
                    }else{
                        self._description = ""
                    }
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0{
                    if let nextEvolution = evolutions[0]["to"] as? String{
                        if nextEvolution.range(of: "mega") == nil{
                            self._nextEvoName = nextEvolution
                        }
                    }else{
                        self._nextEvoName = ""
                    }
                    
                    if let uri = evolutions[0]["resource_uri"] as? String{
                        let newString = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                        let newEvoId = newString.replacingOccurrences(of: "/", with: "")
                        self._nextEvoId = newEvoId
                    }else{
                        self._nextEvoId = ""
                    }
                    
                    if let lvlExist = evolutions[0]["level"]{
                        if let lvl = lvlExist as? Int{
                            self._nextEvoLvl = "\(lvl)"
                        }
                    }else{
                        if let tradeExist = evolutions[0]["method"] as? String{
                            self._evoMethod = true
                            self._nextEvoLvl = tradeExist.capitalized
                        }else{
                             self._evoMethod = false
                             self._nextEvoLvl = ""
                        }
                    }
                    
                    
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0{
                    if let name = types[0]["name"]{
                        self._type = name.capitalized
                    }
                    if types.count > 1{
                        for x in 1..<types.count{
                            if let names = types[x]["name"]{
                                self._type! += "/\(names.capitalized)"
                            }
                        }
                    }
                                        
                }else{
                    self._type = ""
                }
            }
            completed()
        }
    }
    
}
