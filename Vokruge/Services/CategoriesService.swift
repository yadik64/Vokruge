//
//  CategoriesService.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 09.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import Swinject
import RxSwift

protocol CategoriesService {

    func getCategories() -> Observable<[Categories]>
    
    func getAllCategories() -> Observable<[Categories]>
    
    func getCategories(byId id: Int) -> Observable<[Categories]>
    
    func searchCompany(byText text: String) -> Observable<[Company]>
    
    func getCompanyDetails(byId id: Int) -> Observable<Company>
    
}

class CategoriesServiceImpl: CategoriesService {

    let categoriesApi: CategoriesApi


    init(categoriesApi: CategoriesApi) {
        self.categoriesApi = categoriesApi
    }
    
    func getCompanyDetails(byId id: Int) -> Observable<Company> {
        return categoriesApi.getCompanyDetails(byId: id)
            .flatMapLatest { (serverCompany) -> Observable<Company> in
                return Observable.just(CompanyEntityMapper().toLocal(serverEntity: serverCompany))
        }
    }
    
    func searchCompany(byText text: String) -> Observable<[Company]> {
        return categoriesApi.searchCompany(byText: text)
            .flatMapLatest { (serverCompanies) -> Observable<[Company]> in
                return Observable.just(mapNotNull(CompanyEntityMapper().toLocal(list: serverCompanies)))
        }
    }

    func getCategories() -> Observable<[Categories]> {
        return categoriesApi.getCategories()
            .flatMapLatest { (serverCategories) -> Observable<[Categories]> in
                return Observable.just(mapNotNull(CategoriesEntityMapper().toLocal(list: serverCategories)))
        }
    }
    
    func getAllCategories() -> Observable<[Categories]> {
        return categoriesApi.getAllCategories()
            .flatMapLatest { (serverCategories) -> Observable<[Categories]> in
                return Observable.just(mapNotNull(CategoriesEntityMapper().toLocal(list: serverCategories)))
        }
    }
    
    func getCategories(byId id: Int) -> Observable<[Categories]> {
        return categoriesApi.getCategories(byId: id)
            .flatMapLatest { (serverCategories) -> Observable<[Categories]> in
                return Observable.just(mapNotNull(CategoriesEntityMapper().toLocal(list: serverCategories)))
        }
    }

}

class StoriesServiceAssembly: Assembly {

    func assemble(container: Container) {
        container.register(CategoriesService.self) { r in
            let categoriesApi = CategoriesApiImpl()
            return CategoriesServiceImpl(categoriesApi: categoriesApi)
            }
            .inObjectScope(.container)
    }

}


