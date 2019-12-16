//
//  RxFlow+Extensions.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 03.12.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import RxFlow
import Swinject

extension Flow {
    
    private func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    private func appAssembler() -> Assembler {
        return appDelegate().assembler
    }

    func appResolver() -> Resolver {
        return appAssembler().resolver
    }

}
