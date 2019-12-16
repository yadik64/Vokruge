//
//  SearchHistoryViewViewModel.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 30.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchHistoryViewViewModel: ViewModel {
    
    struct External {
        let searchText = PublishRelay<String>()
    }
    
    struct Input {
        let searchText = PublishRelay<String>()
        let deleteText = PublishRelay<Int>()
        let deleteAllHistory = PublishRelay<Void>()
        let historySearchText = PublishRelay<String>()
    }
    
    struct Output {
        var history = BehaviorRelay<[String]>(value: [])
    }
    
    var external = External()
    private(set) var input = Input()
    private(set) var output = Output()
    
    private let service: CategoriesService!
    private let storage: PhoneStorage!
    private let disposeBag = DisposeBag()
    
    init(service: CategoriesService,
         storage: PhoneStorage) {
        self.service = service
        self.storage = storage
        
        getSearchHistory()
        saveSearchHistory()
        deleteHistoryText()
        clearHistory()
        searchText()
        
    }
    
    private func searchText() {
        input.searchText.asObservable()
            .subscribe(onNext: { [unowned self] text in
                self.external.searchText.accept(text)
            })
        .disposed(by: disposeBag)
    }
    
    func getSearchHistory() {
        output.history.accept(storage.getSearchHistory())
    }
    
    private func saveSearchHistory() {
        input.searchText.asObservable()
            .subscribe(onNext: { [unowned self] text in
                self.storage.saveSearchHistory(text)
            }).disposed(by: disposeBag)
    }
    
    private func deleteHistoryText() {
        input.deleteText.asObservable()
            .subscribe(onNext: { [unowned self] index in
                self.storage.deleteHistoryText(atIndex: index)
                self.output.history.accept(self.storage.getSearchHistory())
            }).disposed(by: disposeBag)
    }
    
    private func clearHistory() {
        input.deleteAllHistory.asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.storage.deleteAllHistory()
                self.output.history.accept(self.storage.getSearchHistory())
            }).disposed(by: disposeBag)
    }
}
