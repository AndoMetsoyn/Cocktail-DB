//
//  CategoryDrinks.swift
//  Cocktail-DB
//
//  Created by Ando Metsoyan on 7/25/21.
//

import Foundation

struct CategoryDrinks: Codable {
    var strDrink: String?
    var strDrinkThumb: String?

    enum CodingKeys: String, CodingKey {
        case strDrink
        case strDrinkThumb
    }
}
