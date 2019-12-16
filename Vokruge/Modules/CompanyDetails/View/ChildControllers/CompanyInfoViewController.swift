//
//  CompanyInfoViewController.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 03.12.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit
import Reusable
import XLPagerTabStrip

final class CompanyInfoViewController: BaseViewController, IndicatorInfoProvider, StoryboardBased, ViewModelBased {
    
    var viewModel: CompanyInfoViewModel!
    var itemInfo: IndicatorInfo!
    
    func setItemInfo(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }

}
