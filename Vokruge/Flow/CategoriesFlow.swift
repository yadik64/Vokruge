//
//  CategoriesFlow.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 19.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import UIKit

class CategoriesFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = UINavigationController()
    private let secondStepper: CategoriesStepper
    
    init(stepper: CategoriesStepper) {
        self.secondStepper = stepper
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .allCategories:
            return navigateToMovieListScreen()
        default:
            return .none
        }
    }
    
    private func navigateToMovieListScreen() -> FlowContributors {
        let viewController = AllCategoriesViewController()
        guard let service = viewController.appResolver().resolve(CategoriesService.self) else { return FlowContributors.none }
        let viewModel = AllCategoriesViewModel(service: service)
        viewController.setViewModel(viewModel: viewModel)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: viewController, withNextStepper: viewModel))
        
    }
    
}

class CategoriesStepper: Stepper {
    
    var steps = PublishRelay<Step>()
    
    
    init() {
        self.steps.accept(AppStep.allCategories)
    }

}

