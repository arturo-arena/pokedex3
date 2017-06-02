//
//  PokemonDetailVC.swift
//  Pokedex3
//
//  Created by Arturo on 2017-05-31.
//  Copyright © 2017 Arturo Arena. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexIdLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var evolutionLbl: UILabel!
    @IBOutlet weak var currentEvoLbl: UIImageView!
    @IBOutlet weak var evolutionImg: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // load pokemon image from assests
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoLbl.image = img
        
        pokemon.downloadPokemonDetails {
            self.updateUI()
        }
        

    }
    
    func updateUI() {
        nameLbl.text = pokemon.name.capitalized
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = "\(pokemon.defense)"
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        pokedexIdLbl.text = "\(pokemon.pokedexId)"
        baseAttackLbl.text = String(pokemon.attack)
        evolutionLbl.text = pokemon.nextEvolution
        if pokemon.nextEvolutionId == "" {
            evolutionImg.isHidden = true
        } else {
            evolutionImg.isHidden = false
            evolutionImg.image = UIImage(named: pokemon.nextEvolutionId)
        }
        
    }


    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
