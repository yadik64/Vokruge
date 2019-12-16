//
//  MainFlow.swift
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

class MainFlow: Flow, Assembly {
    
    func assemble(container: Container) {
    }
    
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController = UINavigationController()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return FlowContributors.none }
        
        switch step {
        case .mainScreen:
            return navigateToMainVC()
        case .searchResultScreen(let searchText):
            return navigateToSearchResultVC(text: searchText)
        case .companyDetails(let company):
            return navigateToCompanyDetailsVC(company: company)
        default:
            return FlowContributors.none
        }
    }
    
    private func navigateToMainVC() -> FlowContributors {
        guard let service = appResolver().resolve(CategoriesService.self),
            let storage = appResolver().resolve(PhoneStorage.self) else { return FlowContributors.none }
        let viewModel = MainViewControllerViewModel(service: service, storage: storage)
        let viewController = MainViewController.instantiate(withViewModel: viewModel)
        rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: viewController,
                                                                withNextStepper: viewModel))
    }
    
    private func navigateToSearchResultVC(text: String) -> FlowContributors {
        guard let service = appResolver().resolve(CategoriesService.self),
              let storage = appResolver().resolve(PhoneStorage.self) else { return FlowContributors.none }
        let viewModel = SearchResultViewModel(searchText: text, storage: storage, service: service)
        let vc = SearchResultViewController.instantiate(withViewModel: viewModel)
        rootViewController.pushViewController(vc, animated: false)
        
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: vc,
                                                                withNextStepper: viewModel))
    }
    
    private func navigateToCompanyDetailsVC(company: Company) -> FlowContributors {
        guard let service = appResolver().resolve(CategoriesService.self)
               else { return FlowContributors.none }
        let viewModel = CompanyDetailsViewModel(company: company,
                                                service: service)
        let vc = CompanyDetailsViewController.instantiate(withViewModel: viewModel)
        rootViewController.pushViewController(vc, animated: false)
        
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: vc,
                                                                withNextStepper: viewModel))
    }
    
}
