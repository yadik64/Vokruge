//
//  ServerCategories.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 25.10.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import ObjectMapper

struct ServerCategoriesResponse: Mappable {
    
    var categories: [ServerCategories] = []
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
    
        categories <- map["categories"]
        
    }
}

struct ServerCategories: Mappable {
    
    var id: Int?
    var caption: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
    
        id <- map["id"]
        caption <- map["caption"]
        
    }
}
