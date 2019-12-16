//
//  MainViewController.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 19.10.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Mapbox
import Reusable
import UIKit
import RxSwift
import RxCocoa

final class MainViewController: BaseViewController, StoryboardBased, ViewModelBased {
    
    @IBOutlet private weak var mapView: MGLMapView!
    
    private let searchBar = SearchButtonView(frame: .zero)
    private let disposeBag = DisposeBag()
    private var sosnoviyBor: MGLCoordinateBounds!
    private var navigationBarView = UIView(frame: .zero)
    private var searchHistoryVC: SearchHistoryViewController!
    private var navigationViewWidth: CGFloat = 0
    private var navigationViewHeight: CGFloat = 0
    
    private let keyboardHeight = BehaviorRelay<CGFloat>(value: 0)
    
    var viewModel: MainViewControllerViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNotifications()
        createSearchHistoryVC()
        configurationNavigationBar()
        configurationMap()
        setupSearchBar()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.searchTextField.text = nil
        searchBar.searchTextField.resignFirstResponder()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    deinit {
        print("MAIN SCREEN DESTROYED")
    }
    
    private func addNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    private func createSearchHistoryVC() {
        viewModel.output.history.asObservable()
        .subscribe(onNext: { (history) in
            let searchViewModel = self.viewModel.createSearchHistoryViewModel()
            self.searchHistoryVC = SearchHistoryViewController.instantiate(withViewModel: searchViewModel)
        }).disposed(by: disposeBag)
    }
    
    private func configurationNavigationBar() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        
        let statusBarSizeHeight = UIApplication.shared.statusBarFrame.size.height
        
        navigationViewWidth = navigationController.navigationBar.frame.width
        navigationViewHeight = navigationController.navigationBar.frame.height + statusBarSizeHeight + 10
        
        navigationBarView = UIView(frame: CGRect(x: 0, y: -navigationViewHeight, width: navigationViewWidth, height: navigationViewHeight))
        navigationBarView.backgroundColor = .navigationBarTintColor
        mapView.addSubview(navigationBarView)
        
        addChild(searchHistoryVC)
        searchHistoryVC.view.frame = CGRect(x: 0,
                                    y: view.frame.height,
                                    width: view.frame.width,
                                    height: view.frame.height - navigationBarView.frame.height)
        view.addSubview(searchHistoryVC.view)
        searchHistoryVC.didMove(toParent: self)
        
    }
    
    private func setupSearchBar() {
        guard let navifationBar = navigationController?.navigationBar else { return }
        searchBar.widthContstraint.constant = navifationBar.frame.width - 80
        searchBar.searchBarButton.addTarget(self, action: #selector(stateToggle), for: .touchUpInside)
        searchBar.searchTextField.tintColor = UIColor.black
        searchBar.searchTextField.tintColorDidChange()
        
        navigationItem.titleView = searchBar

        searchBar.searchTextField.rx.controlEvent([.editingDidEndOnExit]).subscribe { [unowned self] text in
            let searchText = self.searchBar.searchTextField.text ?? ""
            self.viewModel.input.searchText.accept(searchText)
        }.disposed(by: disposeBag)
        
        searchBar.searchTextField.rx.isFirstResponder.asObservable()
            .subscribe(onNext: { [unowned self] isFirstResponder in
                if isFirstResponder {
                    self.searchBarActivity()
                } else {
                    self.searchBarDeactivity()
                }
            }).disposed(by: disposeBag)
    }
    
    private func searchBarActivity() {
        keyboardHeight.asObservable().subscribe(onNext: { (height) in
            UIView.animate(withDuration: 0.3, delay: 0, options:
                        UIView.AnimationOptions.curveEaseOut, animations: {
                            self.navigationBarView.frame = CGRect(x: 0,
                                                                  y: 0,
                                                                  width: self.navigationViewWidth,
                                                                  height: self.navigationViewHeight)
                            self.searchHistoryVC.view.frame = CGRect(x: 0,
                                                                     y: self.navigationBarView.frame.height,
                                                                     width: self.view.frame.width,
                                                                     height: self.view.frame.height - self.navigationBarView.frame.height - height)
                            self.searchBar.setBackButtonIconInSerachBar()
                          }, completion: { finished in
                    })
            }).disposed(by: disposeBag)
        
    }
    
    private func searchBarDeactivity() {
        UIView.animate(withDuration: 0.3, delay: 0, options:
            UIView.AnimationOptions.curveEaseOut, animations: {
                self.navigationBarView.frame = CGRect(x: 0,
                                                      y: -self.navigationViewHeight,
                                                      width: self.navigationViewWidth,
                                                      height: self.navigationViewHeight)
                self.searchHistoryVC.view.frame = CGRect(x: 0,
                                                         y: self.view.frame.height,
                                                         width: self.view.frame.width,
                                                         height: self.view.frame.height - self.navigationBarView.frame.height)
                self.searchBar.setSearchIconInSerachBar()
              }, completion: { finished in
        })
    }
    
    @objc private func stateToggle() {
        if searchBar.searchTextField.isFirstResponder {
            searchBarDeactivity()
            searchBar.searchTextField.resignFirstResponder()
        } else {
            searchBarActivity()
            searchBar.searchTextField.becomeFirstResponder()
        }
    }
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        if let keyboardRectValue = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight.accept(keyboardRectValue.height)
        }
    }
    
}

extension MainViewController {
    
    private func configurationMap() {
        mapView.delegate = self
        
        let center = CLLocationCoordinate2D(latitude: 59.865715, longitude: 29.082308)
        mapView.setCenter(center, zoomLevel: 10, direction: 0, animated: false)
        let southwest = CLLocationCoordinate2D(latitude: 59.780022, longitude: 28.839989)
        let northeast = CLLocationCoordinate2D(latitude: 59.950000, longitude: 29.190000)
        sosnoviyBor = MGLCoordinateBounds(sw: southwest, ne: northeast)
    }
}

extension MainViewController: MGLMapViewDelegate {
    
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
}


