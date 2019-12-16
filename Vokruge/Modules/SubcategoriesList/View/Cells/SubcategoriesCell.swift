//
//  SubcategoriesCell.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 23.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit
import Reusable

class SubcategoriesCell: UITableViewCell, NibReusable {
    
    @IBOutlet private weak var subcategoriesNameLabel: UILabel!
    @IBOutlet private weak var rightChevronImageView: UIImageView! {
        didSet {
            rightChevronImageView.image = R.image.chevronRight()
        }
    }

    func configurationCell(category: Categories) {
        subcategoriesNameLabel.text = category.caption
    }
    
}
