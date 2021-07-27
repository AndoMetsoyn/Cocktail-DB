//
//  ApiEnvironment.swift
//  Cocktail-DB
//
//  Created by Ando Metsoyan on 7/26/21.
//

import Foundation

enum ApiEnvironment: String {
    
    case startingURL = "https://www.thecocktaildb.com/api/json/"
    //case qaURL = "www.thecocktaildb.com/api/json/"
    //case prodactionURL = "www.thecocktaildb.com/api/json/
    
    var appVersion:  String  {
        return "v1/1"
    }

    var baseURL: URL {
        return URL(string: "\(self.rawValue)\(self.appVersion)/")!
    }
}




