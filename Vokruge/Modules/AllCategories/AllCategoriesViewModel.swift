//
//  AllCategoriesViewModel.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 08.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import RxFlow
import RxCocoa
import RxSwift

final class AllCategoriesViewModel: ViewModel, Stepper {
    
    struct Input {
        var tapToCategories = PublishRelay<Int>()
    }
    struct Output {
        var categories = BehaviorRelay<[Categories]>(value: [])
    }
    
    
    var output = Output()
    var input = Input()
    
    var steps = PublishRelay<Step>()
    private let service: CategoriesService!
    private let disposeBag = DisposeBag()
    
    
    
    init(service: CategoriesService) {
        self.service = service
        
        bindNavigation()
        
        service.getCategories().asObservable()
            .subscribe(onNext: { [unowned self] categories in
                var categoriesCopy = categories
                let more = categoriesCopy.firstIndex { (category) -> Bool in
                    return category.id == 17
                }
                
                if let index = more {
                    categoriesCopy.remove(at: index)
                    categoriesCopy.append(categories[index])
                }
                
                self.output.categories.accept(categoriesCopy)
            }).disposed(by: disposeBag)
    }
    
    private func bindNavigation() {
        
        input.tapToCategories.asObservable()
            .subscribe(onNext: { [unowned self] id in
                self.steps.accept(AppStep.subcategories(id))
            }).disposed(by: disposeBag)
        
    }
    
}
