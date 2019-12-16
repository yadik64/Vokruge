//
//  CategoriesApi.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 08.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import AlamofireObjectMapper

protocol CategoriesApi {
    
    func getCategories() -> Observable<[ServerCategories]>
    
    func getAllCategories() -> Observable<[ServerCategories]>
    
    func getCategories(byId id: Int) -> Observable<[ServerCategories]>
    
    func searchCompany(byText text: String) -> Observable<[ServerCompany]>
    
    func getCompanyDetails(byId id: Int) -> Observable<ServerCompany>

}

class CategoriesApiImpl: CategoriesApi {
    
    func searchCompany(byText text: String) -> Observable<[ServerCompany]> {
        return Observable.create { (observer) -> Disposable in
            Alamofire.request("http://dev.vokruge.info/api/v1_0/company/search/\(text)".encodeUrl,
                              method: .get,
                              parameters: nil,
                              encoding: JSONEncoding.default,
                              headers: nil)
            .validate()
                .responseObject { (response: DataResponse<ServerCompanyResponse>) in
                    guard let companies = response.value?.companies else {
                        observer.onError(response.error ?? ApiError.noData)
                        return
                    }
                    observer.onNext(companies)
            }
            return Disposables.create()
        }
    }
    
    func getCompanyDetails(byId id: Int) -> Observable<ServerCompany> {
        return Observable.create { (observer) -> Disposable in
            Alamofire.request("http://dev.vokruge.info/api/v1_0/company/\(id)",
                              method: .get,
                              parameters: nil,
                              encoding: JSONEncoding.default,
                              headers: nil)
            .validate()
                .responseObject { (response: DataResponse<ServerCompany>) in
                    guard let companies = response.value else {
                        observer.onError(response.error ?? ApiError.noData)
                        return
                    }
                    observer.onNext(companies)
            }
            return Disposables.create()
        }
    }
    
    func getCategories() -> Observable<[ServerCategories]> {
        return Observable.create { (observer) -> Disposable in
            Alamofire.request("http://dev.vokruge.info/api/v1_0/categories/",
                              method: .get,
                              parameters: nil,
                              encoding: JSONEncoding.default,
                              headers: nil)
            .validate()
                .responseObject { (response: DataResponse<ServerCategoriesResponse>) in
                    guard let result = response.value?.categories else {
                        observer.onError(response.error ?? ApiError.noData)
                        return
                    }
                    observer.onNext(result)
            }
            return Disposables.create()
        }
    }
    
    func getAllCategories() -> Observable<[ServerCategories]> {
        return Observable.create { (observer) -> Disposable in
            Alamofire.request("http://dev.vokruge.info/api/v1_0/categories/all",
                              method: .get,
                              parameters: nil,
                              encoding: JSONEncoding.default,
                              headers: nil)
            .validate()
                .responseObject { (response: DataResponse<ServerCategoriesResponse>) in
                    guard let result = response.value?.categories else {
                        observer.onError(response.error ?? ApiError.noData)
                        return
                    }
                    observer.onNext(result)
            }
            return Disposables.create()
        }
    }
    
    func getCategories(byId id: Int) -> Observable<[ServerCategories]> {
        return Observable.create { (observer) -> Disposable in
            Alamofire.request("http://dev.vokruge.info/api/v1_0/categories/\(id)",
                              method: .get,
                              parameters: nil,
                              encoding: JSONEncoding.default,
                              headers: nil)
            .validate()
                .responseObject { (response: DataResponse<ServerCategoriesResponse>) in
                    guard let result = response.value?.categories else {
                        observer.onError(response.error ?? ApiError.noData)
                        return
                    }
                    observer.onNext(result)
            }
            return Disposables.create()
        }
    }

}

enum ApiError: Error {
    case noData
}

extension String{
    var encodeUrl : String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String
    {
        return self.removingPercentEncoding!
    }
}
