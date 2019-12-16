//
//  UITextField+Extensions.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 29.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UITextField {
    var isFirstResponder: Observable<Bool> {
        return Observable
            .merge(
                methodInvoked(#selector(UIView.becomeFirstResponder)),
                methodInvoked(#selector(UIView.resignFirstResponder))
            )
            .map{ [weak view = self.base] _ in
                view?.isFirstResponder ?? false
            }
            .startWith(base.isFirstResponder)
            .distinctUntilChanged()
            .share(replay: 1)
    }
}
