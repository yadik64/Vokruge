//
//  SubcategoriesListViewModel.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 08.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow

final class SubcategoriesListViewModel: ViewModel, Stepper {
    
    struct Input {
        var tapToCategories = PublishRelay<Int>()
    }
    
    struct Output {
        var categories = BehaviorRelay<[Categories]>(value: [])
    }
    
    var output = Output()
    var input = Input()
    var steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    private let service: CategoriesService
    
    init(service: CategoriesService, categoriesId id: Int) {
        self.service = service
        
        service.getCategories(byId: id).asObservable()
            .subscribe(onNext: { [unowned self] categories in
                self.output.categories.accept(categories)
            }).disposed(by: disposeBag)
    }
    
}
