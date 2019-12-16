//
//  NibLoadingView.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 23.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit

protocol NibDefinable {
    var nibName: String { get }
}

@IBDesignable
class NibLoadingView: UIView, NibDefinable {
    var containerView: UIView!

    var nibName: String {
        if let customNibName = customNibName() {
            return customNibName
        }
        return String(describing: type(of: self))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }

    private func nibSetup() {
        containerView = loadViewFromNib()
        guard let containerView = containerView else {
            preconditionFailure("")
        }
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerView)
        self.addConstraintForAttribute(.top)
        self.addConstraintForAttribute(.left)
        self.addConstraintForAttribute(.bottom)
        self.addConstraintForAttribute(.right)
    }

    private func addConstraintForAttribute(_ attribute: NSLayoutConstraint.Attribute) {
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: attribute,
                                              relatedBy: .equal,
                                              toItem: containerView,
                                              attribute: attribute,
                                              multiplier: 1,
                                              constant: 0.0
        ))
    }

        private func loadViewFromNib() -> UIView? {
            let bundle = Bundle(for: type(of: self))
            return UINib(nibName: nibName, bundle: bundle)
                .instantiate(withOwner: self, options: nil).first as? UIView
        }

        func customNibName() -> String? {
            return nil
        }

}
