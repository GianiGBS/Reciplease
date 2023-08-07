//
//  EdamamURL.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 03/05/2023.
//

import Foundation

// MARK: - Recipe API
protocol EndpointConfig {
    var url : String {get}
    
}
struct EdamamConfig: EndpointConfig {
    
    // MARK: - Properties
    
    private let endpoint = "https://api.edamam.com/api/recipes/v2"
    private let parameter = "?type=public&beta=false"
    var url: String {
         endpoint + parameter
    }
}
