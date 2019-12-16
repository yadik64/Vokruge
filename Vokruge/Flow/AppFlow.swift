//
//  AppFlow.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 26.10.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import RxFlow
import RxSwift
import Swinject

final class AppFlow: Flow {
    
    var root: Presentable {
        return self.rootWindow
    }
    
    private let rootWindow: UIWindow
    
    init(withWindow window: UIWindow) {
        self.rootWindow = window
    }
    
    func navigate(to step: Step) -> FlowContributors {

        guard let step = step as? AppStep else { return FlowContributors.none }

        switch step {
        case .mainScreen:
            return navigationToDashboardScreen()
        default:
            return FlowContributors.none
        }
    }
    
    private func navigationToDashboardScreen() -> FlowContributors {
        let dashboardFlow = DashboardFlow()
        
        Flows.whenReady(flow1: dashboardFlow) { [unowned self] (root) in
            self.rootWindow.rootViewController = root
        }
        
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: dashboardFlow,
                                                                withNextStepper: OneStepper.init(withSingleStep: AppStep.mainScreen)))
        
    }

}

