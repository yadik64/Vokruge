//
//  ServerCompany.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 23.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import ObjectMapper

struct ServerCompanyResponse: Mappable {
    
    var companies: [ServerCompany] = []
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        companies <- map["companies"]
    }
    
}

struct ServerCompany: Mappable {
    
    var id: Int?
    var caption: String?
    var description: String?
    var siteLink: String?
    var email: String?
    var category: [Int] = []
    var coordinates: [ServerCoordinates] = []
    var phoneNumbers: [ServerPhoneData] = []
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        caption <- map["caption"]
        description <- map["description"]
        siteLink <- map["site_link"]
        email <- map["email"]
        category <- map["category"]
        coordinates <- map["coordinates"]
        phoneNumbers <- map["phone_numbers"]
    }
 
}

struct ServerCoordinates: Mappable {

    var id: Int?
    var latitude: Double?
    var longitude: Double?
    var normalAddress: String?
    var rawAddress: String?
    var company: [Int] = []
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        normalAddress <- map["normal_address"]
        rawAddress <- map["raw_address"]
        company <- map["company"]
    }
}

struct ServerPhoneData: Mappable {

    var caption: String?
    var phoneNumber: String?
    var fax: Bool = false
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        caption <- map["caption"]
        phoneNumber <- map["phone_number"]
        fax <- map["fax"]
    }
    
}
