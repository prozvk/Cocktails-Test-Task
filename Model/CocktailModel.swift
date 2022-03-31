//
//  CocktailModel.swift
//  Cocktails
//
//  Created by MacPro on 29.03.2022.
//

import Foundation

struct Drinks: Codable {
    let drinks: [Cocktail]
}

struct Cocktail: Codable {
    let strDrink: String
    let strDrinkThumb: String
    let idDrink: String
}
