//
//  DrinksBaseModel.swift
//  Cocktail-DB
//
//  Created by Ando Metsoyan on 7/25/21.
//

import Foundation

struct DrinksBaseModel <T:Codable> : Codable {
    let drinks: T?
    
    enum CodingKeys: String, CodingKey {
        case drinks
    }
}
