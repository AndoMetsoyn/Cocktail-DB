//
//  Category.swift
//  Cocktail-DB
//
//  Created by Ando Metsoyan on 7/25/21.
//

import Foundation

struct CategoryList: Codable {
    var strCategory: String?
    
    enum CodingKeys: String, CodingKey {
        case strCategory
    }
}
