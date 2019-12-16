//
//  MainViewModel.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 24.10.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow

final class MainViewControllerViewModel: ViewModel, Stepper {
    
    struct Output {
        let history = BehaviorRelay<[String]>(value: [])
    }
    
    struct Input {
        let searchText = PublishRelay<String>()
    }

    var output = Output()
    var input = Input()
    var steps = PublishRelay<Step>()
    
    private let service: CategoriesService!
    private let storage: PhoneStorage!
    private let disposeBag = DisposeBag()
    private let categories = PublishRelay<[Categories]>()
    
    init(service: CategoriesService,
         storage: PhoneStorage) {
        self.service = service
        self.storage = storage
        
        output.history.accept(storage.getSearchHistory())
        
        loadAllCategories()
        saveCategoriesToPhone()
        
        goToSearchResult()
    
    }
    
    func createSearchHistoryViewModel() -> SearchHistoryViewViewModel {
        let viewModel = SearchHistoryViewViewModel(service: service,
                                                   storage: storage)
        viewModel.external.searchText.bind(to: input.searchText).disposed(by: disposeBag)
        
        
        return viewModel
    }
    
    func createSearchResultViewModel(searchText: String) -> SearchResultViewModel {
        let viewModel = SearchResultViewModel(searchText: searchText,
                                              storage: storage,
                                              service: service)
        
        return viewModel
    }
    
    private func loadAllCategories() {
        service.getAllCategories()
        .asObservable()
            .subscribe(onNext: { [unowned self] categories  in
                self.categories.accept(categories)
            }).disposed(by: disposeBag)
    }
    
    private func saveCategoriesToPhone() {
        categories.asObservable()
            .subscribe(onNext: { [unowned self] categories in
                self.storage.saveAllCategories(categories)
            }).disposed(by: disposeBag)
    }
    
    private func goToSearchResult() {
        input.searchText.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] text in
                self.storage.saveSearchHistory(text)
                self.steps.accept(AppStep.searchResultScreen(text))
            })
        .disposed(by: disposeBag)
    }
    
}
