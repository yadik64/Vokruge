//
//  CompanyEntityMapper.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 23.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation

class CompanyEntityMapper: EntityMapper<ServerCompany, Company> {
    
    override func toLocal(serverEntity: ServerCompany) -> Company {
        
        var company = Company(id: serverEntity.id,
                              caption: serverEntity.caption,
                              description: serverEntity.description,
                              siteLink: serverEntity.siteLink,
                              email: serverEntity.email,
                              category: serverEntity.category)
        
        company.coordinates = mapNotNull(CoordinateEntityMapper().toLocal(list: serverEntity.coordinates))
        company.phoneNumbers = mapNotNull(PhoneDataEntityMapper().toLocal(list: serverEntity.phoneNumbers))
        
        return company
    }
}

class CoordinateEntityMapper: EntityMapper<ServerCoordinates, Coordinates> {
    
    override func toLocal(serverEntity: ServerCoordinates) -> Coordinates {
        
        let coordinate = Coordinates(id: serverEntity.id,
                                     latitude: serverEntity.latitude,
                                     longitude: serverEntity.longitude,
                                     normalAddress: serverEntity.normalAddress,
                                     rawAddress: serverEntity.rawAddress,
                                     company: serverEntity.company)
        
        return coordinate
    }
}

class PhoneDataEntityMapper: EntityMapper<ServerPhoneData, PhoneData> {
    
    override func toLocal(serverEntity: ServerPhoneData) -> PhoneData {
        
        let phoneData = PhoneData(caption: serverEntity.caption,
                                   phoneNumber: serverEntity.phoneNumber,
                                   fax: serverEntity.fax)
        
        return phoneData
    }
}
