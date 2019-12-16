//
//  SubcategoriesListViewController.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 08.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

final class SubcategoriesListViewController: BaseViewController, StoryboardBased, ViewModelBased {

    @IBOutlet private weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    var viewModel: SubcategoriesListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackButton()
        bindTableView()
    }
    
    deinit {
        print("SUBCATEGORIES SCREEN DESTROYED")
    }
    
    private func bindTableView() {
        
        tableView.register(cellType: SubcategoriesCell.self)
        
        viewModel.output.categories.bind(to: tableView.rx.items(cellIdentifier: "SubcategoriesCell",
                                                                cellType: SubcategoriesCell.self)) { index, model, cell in
                                                                    cell.configurationCell(category: model)
                                                                }
                                                                .disposed(by: disposeBag)
        
    }

}
