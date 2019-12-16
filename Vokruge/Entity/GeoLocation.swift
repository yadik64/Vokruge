//
//  GeoLocation.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 25.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import MapKit

class GeoLocation: Equatable {

    static func == (lhs: GeoLocation, rhs: GeoLocation) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }

    let latitude: Double
    let longitude: Double

    convenience init(clLocation: CLLocation) {
        self.init(latitude: clLocation.coordinate.latitude,
                   longitude: clLocation.coordinate.longitude)
    }

    convenience init(locationCoordinate: CLLocationCoordinate2D) {
        self.init(latitude: locationCoordinate.latitude,
                  longitude: locationCoordinate.longitude)
    }

    init(latitude: Double,
         longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    func toCGPoint() -> CGPoint {
        return CGPoint(x: latitude, y: longitude)
    }

    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

}
