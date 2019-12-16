//
//  CollectionViewCell.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 23.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

class CategoriesCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet private weak var categoriesIconImageView: UIImageView!
    @IBOutlet private weak var categoriesNameLabel: UILabel!

    func configurationCell(category: Categories) {
        let stringURL = "http://51.158.167.236/static/icons/1x/\(category.id!).png"
        guard let url = URL(string: stringURL) else { return }

        categoriesIconImageView.kf.setImage(with: url)
        categoriesNameLabel.text = category.caption
    }

}
