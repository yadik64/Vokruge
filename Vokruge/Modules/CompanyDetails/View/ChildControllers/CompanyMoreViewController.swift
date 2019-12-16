//
//  CompanyMoreViewController.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 03.12.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit
import XLPagerTabStrip

final class CompanyMoreViewController: UIViewController, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo!
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}
