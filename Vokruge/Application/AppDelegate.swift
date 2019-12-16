//
//  AppDelegate.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 19.10.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit
import RxSwift
import RxFlow
import Swinject
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var assembler: Assembler!
    var window: UIWindow?
    var appFlow: AppFlow!
    let coordinator = FlowCoordinator()
    let disposeBag = DisposeBag()
    var locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        assembler = Assembler([
            StoriesServiceAssembly(),
            PhoneStorageAssembly(),
        ])
        
        guard let window = window else { return false }
        
        appFlow = AppFlow(withWindow: window)

        coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print ("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        self.coordinator.coordinate(flow: appFlow, with: OneStepper(withSingleStep: AppStep.mainScreen))
        
        getCurrentLocation()
        
        return true

    }

}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        CurrentLocations.share.currentLocation = GeoLocation(locationCoordinate: locValue)
    }
    
    private func getCurrentLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

class CurrentLocations {
    
    static var share = CurrentLocations()
    var currentLocation: GeoLocation?
    
    private init(){}
}

