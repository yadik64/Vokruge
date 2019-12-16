//
//  SearchHistoryView.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 29.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchHistoryView: NibLoadingView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    private let storage: PhoneStorage

    init(frame: CGRect, storage: PhoneStorage) {
        self.storage = storage
        super.init(frame: frame)
        print("TEST")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindTableView() {
        
    }
}
