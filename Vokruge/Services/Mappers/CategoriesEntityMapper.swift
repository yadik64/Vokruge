//
//  CategoriesEntityMapper.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 09.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation

class CategoriesEntityMapper: EntityMapper<ServerCategories, Categories> {
    
    override func toLocal(serverEntity: ServerCategories) -> Categories {
        
        let categorie = Categories(id: serverEntity.id,
                                   caption: serverEntity.caption)
        
        return categorie
    }
}

