//
//  EmptyFlow.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 20.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import RxFlow
import RxCocoa
import RxSwift

class EmptyFlow: Flow {
    
    var root: Presentable {
        return rootViewController
    }
    private var rootViewController = EmptyViewController()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return FlowContributors.none }
        
        switch step {
        case .emptyScreen:
            return navigateToEmptyVC()
        default:
            return FlowContributors.none
        }
    }
    
    private func navigateToEmptyVC() -> FlowContributors {
        
        let stepper = OneStepper(withSingleStep: AppStep.emptyScreen)
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: rootViewController,
                                                                withNextStepper: stepper))
    }
    
}
