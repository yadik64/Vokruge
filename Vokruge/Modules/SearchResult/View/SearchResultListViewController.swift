//
//  SearchResultListViewController.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 24.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

final class SearchResultListViewController: PullUpController, StoryboardBased, ViewModelBased {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.allowsSelection = false
        }
    }
    @IBOutlet private weak var headerView: UIView! {
        didSet {
            headerView.clipsToBounds = true
            headerView.layer.cornerRadius = 10.0
            headerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    @IBOutlet private weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = .searchResultSeparatorViewColor
            separatorView.layer.cornerRadius = separatorView.bounds.height / 2
        }
    }
    
    private let disposeBag = DisposeBag()
    var viewModel: SearchResultListViewModel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.attach(to: self)
        bindTableView()
        scrollToSelectedPlace()
    }
    
    deinit {
        print("SEARCH RESULT LIST SCREEN DESTROYED")
    }
    
    private func scrollToSelectedPlace() {
        viewModel.output.markerTap.asObservable()
        .subscribe(onNext: { [unowned self] row in
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        tableView.register(cellType: SearchResultCompanyCell.self)
                
        viewModel.output.companies.bind(to: tableView.rx.items(cellIdentifier: "SearchResultCompanyCell", cellType: SearchResultCompanyCell.self)) { [unowned self] index, company, cell in
            
            let categoriesId = company.category
            var categoriesName = ""
//            for id in categoriesId {
//                categoriesName += self.viewModel.storage.getCategoryName(byId: id)
//            }
            
            let distansesString = company.distanceString(currentCoordinate: CurrentLocations.share.currentLocation ?? GeoLocation(latitude: 0, longitude: 0))
            cell.configurationCell(company: company,
                                   distance: distansesString,
                                   categoriesName: categoriesName,
                                   addressTap: self.viewModel.input.addressTap,
                                   nameCompanyTap: self.viewModel.input.nameCompanyTap)
        }.disposed(by: disposeBag)
    }
    
    override var pullUpControllerPreferredSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width,
                      height: 400)
    }
    
    override var pullUpControllerMiddleStickyPoints: [CGFloat] {
        guard let tabBarHeight = self.tabBarController?.tabBar.frame.height else { return []}
        guard let cellHeight = tableView.cellForRow(at: IndexPath(item: 0, section: 0))?.frame.height else { return [] }
        
        return [cellHeight + tabBarHeight + headerView.frame.height, tabBarHeight + 20]
    }
    
    override func pullUpControllerAnimate(action: PullUpController.Action,
                                          withDuration duration: TimeInterval,
                                          animations: @escaping () -> Void,
                                          completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.3,
        animations: animations,
        completion: completion)
    }

}
