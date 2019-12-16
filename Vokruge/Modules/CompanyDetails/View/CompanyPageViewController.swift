//
//  CompanyPageViewController.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 03.12.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit
import XLPagerTabStrip

final class CompanyPageViewController: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .pagerButtonBarBackground
        settings.style.buttonBarItemBackgroundColor = .pagerButtonBarItemBackground
        settings.style.buttonBarItemFont = R.font.sfProTextRegular(size: 14) ?? .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 0
        settings.style.buttonBarItemLeftRightMargin = 0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarLeftContentInset = 20
        settings.style.buttonBarRightContentInset = 20
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .pagerButtonTitle
            newCell?.label.textColor = .pagerSelectedbuttonTitle
        }
        
        super.viewDidLoad()
        
            view.setNeedsLayout()
            view.layoutIfNeeded()
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let viewModelChildren_1 = CompanyInfoViewModel()
        let child_1 = CompanyInfoViewController.instantiate(withViewModel: viewModelChildren_1)
        let itemInfoChildren_1 = IndicatorInfo(title: R.string.localizable.companyDetailsPageTabInfo())
        child_1.setItemInfo(itemInfo: itemInfoChildren_1)
        
        let child_2 = CompanyReviewsViewController(itemInfo: "ОТЗЫВЫ")
        let child_3 = CompanyMoreViewController(itemInfo: "ПОДРОБНЕЕ")
        
        return [child_1, child_2, child_3]
    }
    
}
