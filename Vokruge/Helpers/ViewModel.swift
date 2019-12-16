//
//  ViewModel.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 24.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Reusable
import UIKit

protocol ViewModel {
}

protocol ViewModelBased: UIViewController {
    associatedtype ViewModelType: ViewModel

    var viewModel: ViewModelType! { get set }
}

extension ViewModelBased where Self: StoryboardBased & UIViewController {
    static func instantiate<ViewModelType> (withViewModel viewModel: ViewModelType) -> Self where ViewModelType == Self.ViewModelType {
        let viewController = Self.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
}
