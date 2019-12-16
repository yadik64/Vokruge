//
//  AllCategoriesFlow.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 20.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import RxCocoa
import RxFlow
import RxSwift
import Swinject

class AllCategoriesFlow: Flow, Assembly {
    
    func assemble(container: Container) {
    }
    
    var root: Presentable {
        return self.rootController
    }
    
    var rootController = UINavigationController()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return FlowContributors.none }
        
        switch step {
        case .allCategories:
            return navigateToAllCategoriesVC()
        case .subcategories(let id):
            return navigateToSubcategories(byId: id)
        default:
            return FlowContributors.none
        }
    }
    
    private func navigateToAllCategoriesVC() -> FlowContributors {
        guard let service = appResolver().resolve(CategoriesService.self) else { return FlowContributors.none }
        let viewModel = AllCategoriesViewModel(service: service)
        let vc = AllCategoriesViewController.instantiate(withViewModel: viewModel)
        rootController.pushViewController(vc, animated: true)
        
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: vc,
                                                                withNextStepper: viewModel))
    }
    
    private func navigateToSubcategories(byId id: Int) -> FlowContributors {
        guard let service = appResolver().resolve(CategoriesService.self) else { return FlowContributors.none }
        let viewModel = SubcategoriesListViewModel(service: service, categoriesId: id)
        let vc = SubcategoriesListViewController.instantiate(withViewModel: viewModel)
        rootController.pushViewController(vc, animated: true)
        
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: vc,
                                                                withNextStepper: viewModel))
    }
    
}
