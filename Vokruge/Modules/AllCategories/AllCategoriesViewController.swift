//
//  AllCategoriesViewController.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 06.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa


final class AllCategoriesViewController: BaseViewController, StoryboardBased, ViewModelBased {
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.sectionInset = UIEdgeInsets(top: 22, left: 0, bottom: 10, right: 0)
            let size = (collectionView.frame.size.width) / CGFloat(5)
            let cellHeight: CGFloat = 90
            flowLayout.itemSize = CGSize(width: size, height: cellHeight)
            collectionView.setCollectionViewLayout(flowLayout, animated: true)
        }
    }
    
    var viewModel: AllCategoriesViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = R.string.localizable.categoriesTitle()
        
        bindCollectionView()
    }
    
    deinit {
        print("ALLCATEGORIES SCREEN DESTROYED")
    }
    
    private func bindCollectionView() {
        
        self.collectionView.register(cellType: CategoriesCell.self)
        
        viewModel.output.categories
            .bind(to: collectionView.rx.items(cellIdentifier: "CategoriesCell", cellType: CategoriesCell.self)){ index, model, cell in
            cell.configurationCell(category: model)
        }
        .disposed(by: disposeBag)
        
        
        collectionView.rx.itemSelected.asObservable()
            .subscribe(onNext: { [unowned self] indexPath in
                guard let id = self.viewModel.output.categories.value[indexPath.row].id else { return }
                self.viewModel.input.tapToCategories.accept(id)
            })
            .disposed(by: disposeBag)
    }

}
