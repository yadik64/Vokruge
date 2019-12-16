//
//  SearchHistoryCell.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 29.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit
import Reusable
import RxCocoa
import RxSwift

final class SearchHistoryCell: UITableViewCell, NibReusable {
    
    @IBOutlet private weak var textContentView: UIView! {
        didSet {
            textContentView.clipsToBounds = true
            textContentView.layer.cornerRadius = 10.0
            textContentView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnText))
            textContentView.addGestureRecognizer(tap)
        }
    }
    @IBOutlet private weak var searchTextLabel: UILabel!

    private var textHistory = ""
    private var tapOnTextRelay = PublishRelay<String>()
    
    func configurationCell(_ text: String, tap: PublishRelay<String>) {
        textHistory = text
        tapOnTextRelay = tap
        searchTextLabel.text = text
    }
    
    @objc private func tapOnText() {
        tapOnTextRelay.accept(textHistory)
    }
    
}
