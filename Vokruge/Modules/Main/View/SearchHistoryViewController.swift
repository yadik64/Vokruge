//
//  SearchHistoryViewController.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 29.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

final class SearchHistoryViewController: BaseViewController, StoryboardBased, ViewModelBased {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
            tableView.allowsSelection = false
        }
    }
    @IBOutlet private weak var emptyContentView: UIView!
    @IBOutlet private weak var historyContentView: UIView!
    @IBOutlet private weak var emptyImageView: UIImageView! {
        didSet {
            emptyImageView.image = R.image.emptyHistory()
        }
    }
    @IBOutlet private weak var emptyLabel: UILabel! {
        didSet {
            emptyLabel.text = R.string.localizable.mainScreenSearchHistoryEmpty()
        }
    }
    @IBOutlet private weak var clearButton: UIButton! {
        didSet {
            clearButton.layer.cornerRadius = 5.0
            clearButton.layer.borderWidth = 1.0
            clearButton.layer.borderColor = UIColor.clearButtonBorderColor.cgColor
            clearButton.setTitle(R.string.localizable.mainScreenSearchClearButton(),
                                 for: .normal)
            clearButton.setTitleColor(.clearButtonTitleColor, for: .normal)
        }
    }
    
    private let disposeBag = DisposeBag()
    var viewModel: SearchHistoryViewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurationEmptyView()
        bindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getSearchHistory()
    }
    
    @IBAction private func clearHistory() {
        viewModel.input.deleteAllHistory.accept(())
    }
    
    private func configurationEmptyView() {
        viewModel.output.history.asObservable()
            .filter { (history) -> Bool in
                history.isEmpty
        }
        .subscribe(onNext: { (_) in
            self.historyContentView.isHidden = true
            self.emptyContentView.isHidden = false
            }).disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        
        tableView.register(cellType: SearchHistoryCell.self)
        
        viewModel.output.history
            .filter({ (history) -> Bool in
                !history.isEmpty
            })
            .do(onNext: { [unowned self] _ in
                self.emptyContentView.isHidden = true
                self.historyContentView.isHidden = false
            })
            .bind(to: tableView.rx.items(cellIdentifier: "SearchHistoryCell", cellType: SearchHistoryCell.self)) { [unowned self] index, text, cell in
                cell.configurationCell(text, tap: self.viewModel.input.searchText)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemDeleted.asObservable()
            .subscribe(onNext: { (indexPath) in
                self.viewModel.input.deleteText.accept(indexPath.row)
            }).disposed(by: disposeBag)
    }

}
