//
//  SearchResultViewController.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 24.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit
import Reusable
import Mapbox
import RxSwift
import RxCocoa

final class SearchResultViewController: BaseViewController, StoryboardBased, ViewModelBased {
    
    @IBOutlet private weak var mapView: MGLMapView!
    
    private let disposeBag = DisposeBag()
    var viewModel: SearchResultViewModel!
    private var sosnoviyBor: MGLCoordinateBounds!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButton()
        configurationMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addPullUpController(animated: true)
        
        viewModel.output.companies.asObservable()
        .subscribe(onNext: { [unowned self] _ in
            self.setMarkers()
        }).disposed(by: disposeBag)
        
        centerMapOnMarker()
    }
    
    deinit {
        print("SEARCH RESULT SCREEN DESTROYED")
    }
    
    private func centerMapOnMarker() {
        viewModel.input.addressTap.asObservable().subscribe(onNext: { [unowned self] locations in
            self.mapView.centerCoordinate = locations.toCLLocationCoordinate2D()
            self.mapView.setZoomLevel(15, animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func SearchResultListViewControllerIfNeeded() -> SearchResultListViewController {
        let viewModel = self.viewModel.createSearchResultListViewModel()
        let currentPullUpController = children
            .filter({ $0 is SearchResultListViewController })
            .first as? SearchResultListViewController
        let pullUpController: SearchResultListViewController = currentPullUpController ?? SearchResultListViewController.instantiate(withViewModel: viewModel)
        
        return pullUpController
    }
    
    private func addPullUpController(animated: Bool) {
        let pullUpController = SearchResultListViewControllerIfNeeded()
        addPullUpController(pullUpController,
                            initialStickyPointOffset: 400,
                            animated: animated)
    }

}

extension SearchResultViewController {
    
    private func configurationMap() {
        mapView.delegate = self
        
        let center = CLLocationCoordinate2D(latitude: 59.865715, longitude: 29.082308)
        mapView.setCenter(center, zoomLevel: 10, direction: 0, animated: false)
        let southwest = CLLocationCoordinate2D(latitude: 59.780022, longitude: 28.839989)
        let northeast = CLLocationCoordinate2D(latitude: 59.950000, longitude: 29.190000)
        sosnoviyBor = MGLCoordinateBounds(sw: southwest, ne: northeast)
    }
    
    private func setMarkers() {
        for company in viewModel.output.companies.value {
            let _latitude = company.coordinates.first?.latitude
            let _longitude = company.coordinates.first?.longitude
            if let latitude = _latitude, let longitude = _longitude {
                let annotation = MGLPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                annotation.title = company.caption
                annotation.subtitle = company.description
                mapView.addAnnotation(annotation)
            }
        }
    }
}

extension SearchResultViewController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool {
        
        let currentCamera = mapView.camera
        let newCameraCenter = newCamera.centerCoordinate
        
        mapView.camera = newCamera
        let newVisibleCoordinates = mapView.visibleCoordinateBounds
        
        mapView.camera = currentCamera
        
        let inside = MGLCoordinateInCoordinateBounds(newCameraCenter, self.sosnoviyBor)
        let intersects = MGLCoordinateInCoordinateBounds(newVisibleCoordinates.ne, self.sosnoviyBor) && MGLCoordinateInCoordinateBounds(newVisibleCoordinates.sw, self.sosnoviyBor)
        
        return inside && intersects
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        let _index = viewModel.output.companies.value.firstIndex { (company) -> Bool in
            return company.caption == annotation.title
        }
        guard let index = _index else { return }
        viewModel.input.markerTap.accept(index)
    }

}

