//
//  SearchResultViewModel.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 24.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxFlow

final class SearchResultViewModel: ViewModel, Stepper {
    
    struct Output {
        let companies = BehaviorRelay<[Company]>(value: [])
    }
    
    struct Input {
        let addressTap = PublishRelay<GeoLocation>()
        let markerTap = PublishRelay<Int>()
        let nameCompanyTap = PublishRelay<Company>()
    }
    
    private let disposeBag = DisposeBag()
    private let storage: PhoneStorage
    private let service: CategoriesService
    
    var steps =  PublishRelay<Step>()
    var output = Output()
    var input = Input()
    
    init(searchText: String,
         storage: PhoneStorage,
         service: CategoriesService) {
        self.storage = storage
        self.service = service
        
        self.service.searchCompany(byText: searchText).asObservable()
            .subscribe(onNext: { (company) in
                self.output.companies.accept(company)
            })
        .disposed(by: disposeBag)
        
        input.nameCompanyTap.asObservable()
            .subscribe(onNext: { [unowned self] company in
                self.steps.accept(AppStep.companyDetails(company))
            })
        .disposed(by: disposeBag)
        
    }
    
    func createSearchResultListViewModel() -> SearchResultListViewModel {
        let viewModel = SearchResultListViewModel()
        viewModel.input.addressTap.bind(to: input.addressTap).disposed(by: disposeBag)
        viewModel.input.nameCompanyTap.bind(to: input.nameCompanyTap).disposed(by: disposeBag)
        input.markerTap.bind(to: viewModel.output.markerTap).disposed(by: disposeBag)
        output.companies.bind(to: viewModel.output.companies).disposed(by: disposeBag)
        return viewModel
    }
    
}
