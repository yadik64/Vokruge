//
//  BaseViewController.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 23.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.navigationBarTextColor]
        navigationController?.navigationBar.barTintColor = .navigationBarTintColor
        navigationController?.navigationBar.tintColor = .navigationBarButtonColor
    }
    
    func setupBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: R.image.backButton(),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(back))
    }
    
    @objc func back() {
        if let navigationController = self.navigationController {
            if navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: false)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
