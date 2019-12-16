//
//  AppStep.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 07.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import RxFlow

enum AppStep: Step {
    case mainScreen
    case searchResultScreen(String)
    case companyDetails(Company)
    case allCategories
    case subcategories(Int)
    case emptyScreen
}
