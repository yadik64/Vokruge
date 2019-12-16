//
//  CompanyDetailsViewController.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 03.12.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit
import Reusable
import XLPagerTabStrip

final class CompanyDetailsViewController: BaseViewController, StoryboardBased, ViewModelBased {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var companyImage: UIImageView!

    
    
    private lazy var pageVC = CompanyPageViewController()
    var viewModel: CompanyDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPageVC()
        configurationNavigationBar()
        setupBackButton()
        configurationLeftNavigationBarButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    deinit {
        print("COMPANY DETAILS SCREEN DESTROYED")
    }
    
    private func addPageVC() {
        addChild(pageVC)
        pageVC.view.frame = contentView.frame
        view.addSubview(pageVC.view)
        pageVC.didMove(toParent: self)
    }
    
    private func configurationNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func configurationLeftNavigationBarButton() {
        let heartButton = UIBarButtonItem(image: R.image.heart(),
                                          style: .done, target: self,
                                          action: #selector(addToFavorites))
        navigationItem.rightBarButtonItem = heartButton
    }
    
    @objc private func addToFavorites() {
        print("FAVORITES")
    }
    

}
