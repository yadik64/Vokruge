//
//  UIViewControllerExtensions.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 09.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit
import Swinject

extension UIViewController {

    // swiftlint:disable force_cast
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func appAssembler() -> Assembler {
        return appDelegate().assembler
    }

    func appResolver() -> Resolver {
        return appAssembler().resolver
    }

}

