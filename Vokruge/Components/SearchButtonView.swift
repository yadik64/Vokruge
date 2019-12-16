//
//  SearchButton.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 23.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit

class SearchButtonView: NibLoadingView {

    @IBOutlet weak var widthContstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.returnKeyType = .search
        }
    }
    @IBOutlet weak var searchBarIconImageView: UIImageView! {
        didSet {
            searchBarIconImageView.image = R.image.searchBarSearch()
        }
    }
    

    override init(frame: CGRect) {
         super.init(frame: frame)
        
        configurationView()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }
    
    private func configurationView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.0
    }
    
    func setBackButtonIconInSerachBar() {
        searchBarIconImageView.image = R.image.searchBarBack()
    }
    
    func setSearchIconInSerachBar() {
        searchBarIconImageView.image = R.image.searchBarSearch()
    }
}
