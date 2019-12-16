//
//  SearchResultListViewModel.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 24.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class SearchResultListViewModel: ViewModel {
    
    struct Output {
        let companies = BehaviorRelay<[Company]>(value: [])
        var markerTap = PublishRelay<Int>()
    }
    
    struct Input {
        var addressTap = PublishRelay<GeoLocation>()
        var nameCompanyTap = PublishRelay<Company>()
    }
    
    private let disposeBag = DisposeBag()
    
    var output = Output()
    var input = Input()
    
}
