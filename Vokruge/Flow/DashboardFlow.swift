//
//  DashboardFlow.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 20.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import UIKit
import RxFlow

class DashboardFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    let rootViewController = UITabBarController()
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return FlowContributors.none }
        
        switch step {
        case .mainScreen:
            return navigateToDashboard()
        default:
            return .none
        }
    }
    
    private func navigateToDashboard() -> FlowContributors {
        let mainFlow = MainFlow()
        let allCategoriesFlow = AllCategoriesFlow()
        let emptyFlow = EmptyFlow()
        let emptyFlow2 = EmptyFlow()
        let emptyFlow3 = EmptyFlow()
        
        Flows.whenReady(flow1: mainFlow,
                        flow2: allCategoriesFlow,
                        flow3: emptyFlow,
                        flow4: emptyFlow2,
                        flow5: emptyFlow3) { [unowned self] (root1: UINavigationController,
                            root2: UINavigationController,
                            root3: EmptyViewController,
                            root4: EmptyViewController,
                            root5: EmptyViewController) in
                            
                            let tabBarItem1 = UITabBarItem(title: R.string.localizable.tabBarItemMap(),
                                                           image: R.image.tabMap(),
                                                           selectedImage: nil)
                            let tabBarItem2 = UITabBarItem(title: R.string.localizable.tabBarItemCategories(),
                                                           image: R.image.tabCategories(),
                                                           selectedImage: nil)
                            let tabBarItem3 = UITabBarItem(title: R.string.localizable.tabBarItemPromotion(),
                                                           image: R.image.tabPromotion(),
                                                           selectedImage: nil)
                            let tabBarItem4 = UITabBarItem(title: R.string.localizable.tabBarItemEvents(),
                                                           image:R.image.tabEvents(),
                                                           selectedImage: nil)
                            let tabBarItem5 = UITabBarItem(title: R.string.localizable.tabBarItemOther(),
                                                           image: R.image.tabMore(),
                                                           selectedImage: nil)

            root1.tabBarItem = tabBarItem1
            root2.tabBarItem = tabBarItem2
            root3.tabBarItem = tabBarItem3
            root4.tabBarItem = tabBarItem4
            root5.tabBarItem = tabBarItem5
            
            self.rootViewController.setViewControllers([root1, root2, root3, root4, root5], animated: false)
        }
        
        rootViewController.tabBar.tintColor = .tabBarTintColor
                
        return .multiple(flowContributors: [FlowContributor.contribute(withNextPresentable: mainFlow,
                                                                       withNextStepper: OneStepper(withSingleStep: AppStep.mainScreen)),
                                            FlowContributor.contribute(withNextPresentable: allCategoriesFlow,
                                                                       withNextStepper: OneStepper(withSingleStep: AppStep.allCategories)),
                                            FlowContributor.contribute(withNextPresentable: emptyFlow,
                                                                       withNextStepper: OneStepper(withSingleStep: AppStep.emptyScreen)),
                                            FlowContributor.contribute(withNextPresentable: emptyFlow2,
                                                                       withNextStepper: OneStepper(withSingleStep: AppStep.emptyScreen)),
                                            FlowContributor.contribute(withNextPresentable: emptyFlow3,
                                                                       withNextStepper: OneStepper(withSingleStep: AppStep.emptyScreen))])
        
    }
}
