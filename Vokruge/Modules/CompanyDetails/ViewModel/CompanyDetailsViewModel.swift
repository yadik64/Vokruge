//
//  CompanyDetailsViewModel.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 03.12.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow

final class CompanyDetailsViewModel: Stepper, ViewModel {
    
    var steps = PublishRelay<Step>()
    
    struct Output {
        let companyDetails = PublishRelay<CompanyDetails>()
    }
    
    private let disposeBag = DisposeBag()
    private let service: CategoriesService
    
    init(company: Company,
         service: CategoriesService) {
        self.service = service
        guard let id = company.id else { return }
        service.getCompanyDetails(byId: id).asObservable()
            .subscribe(onNext: { (company) in
                
                print(company)
                
            }).disposed(by: disposeBag)
    }
}
