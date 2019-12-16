//
//  MapScreenFlow.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 19.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import UIKit

class MapScreenFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = UINavigationController()
    private let mainStepper: MapScreenStepper
    
    init(stepper: MapScreenStepper) {
        self.mainStepper = stepper
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .mainScreen:
            return navigateToMainScreen()
        default:
            return .none
        }
    }
    
    private func navigateToMainScreen() -> FlowContributors {
        let viewController = MainViewController()
        let viewModel = MainViewControllerViewModel()
        viewController.setViewModel(viewModel: viewModel)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: viewController, withNextStepper: viewModel))
        
    }
    
}

class MapScreenStepper: Stepper {
    
    var steps = PublishRelay<Step>()
        
    init() {
        self.steps.accept(AppStep.mainScreen)
    }

}
