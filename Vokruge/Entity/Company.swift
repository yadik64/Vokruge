//
//  Company.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 23.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import CoreLocation

struct Company {
    
    var id: Int?
    var caption: String?
    var description: String?
    var siteLink: String?
    var email: String?
    var category: [Int] = []
    var coordinates: [Coordinates] = []
    var phoneNumbers: [PhoneData] = []
    
    func distanceString(currentCoordinate: GeoLocation) -> String {
        guard let lat = self.coordinates.first?.latitude,
            let long = self.coordinates.first?.longitude
            else { return "" }
        guard let latLocationDegrees = CLLocationDegrees(exactly: lat),
              let longLocationDegrees = CLLocationDegrees(exactly: long)
            else { return "" }

        let currentLocation = CLLocation(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
        let placeLocation = CLLocation(latitude: latLocationDegrees, longitude: longLocationDegrees)

        let distance = Int(currentLocation.distance(from: placeLocation))

        var distanceString = ""

        if distance < 1000 {
            distanceString = String(describing: distance) + " м."
        } else {
            distanceString = String(describing: distance / 1000) + " км."
        }

        return distanceString
    }
}

struct Coordinates {

    var id: Int?
    var latitude: Double?
    var longitude: Double?
    var normalAddress: String?
    var rawAddress: String?
    var company: [Int] = []
}

struct PhoneData {

    var caption: String?
    var phoneNumber: String?
    var fax: Bool = false
}
