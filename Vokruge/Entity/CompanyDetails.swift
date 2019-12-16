//
//  CompanyDetails.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 04.12.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation

enum CompanyDetails {
    case address(CompanyDetailsAdress)
    case workShedule(CompanyDetailsWorkShedule)
    case contacts(CompanyDetailsContacts)
    case socialNetworks(CompanyDetailsSocialNetworks)
    case banner(CompanyDetailsBanner)
    case photos(CompanyDetailsPhotos)
}

struct CompanyDetailsAdress {
    let address: String
    let coordinates: GeoLocation?
}

struct CompanyDetailsWorkShedule {
    
}

struct CompanyDetailsContacts {
    let phoneNumbers: [String]
    let site: String
    let email: String
}

struct CompanyDetailsSocialNetworks {
    
}

struct CompanyDetailsBanner {
    
}

struct CompanyDetailsPhotos {
    let photos: [String]
}
