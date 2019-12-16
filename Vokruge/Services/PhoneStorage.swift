//
//  PhoneStorage.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 27.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation
import Swinject
import RxSwift

enum UserDefaultsData: String {
    case allCategories = "AllCategories"
    case requestHistory = "RequestHistory"
}

protocol PhoneStorage {
    func saveAllCategories(_ categories: [Categories])
    
    func getAllCategories() -> Observable<[Categories]>
    
    func getCategoryName(byId id: Int) -> String
    
    func saveSearchHistory(_ text: String)
    
    func getSearchHistory() -> [String]
    
    func deleteHistoryText(atIndex index: Int)
    
    func deleteAllHistory()
}

final class PhoneStorageImpl: PhoneStorage {
    
    private let defaults = UserDefaults.standard
    private let disposeBag = DisposeBag()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var allCategories: [Categories] = []
    
    func deleteHistoryText(atIndex index: Int) {
        var historyArray = getSearchHistory()
        historyArray.remove(at: index)
        defaults.set(historyArray, forKey: UserDefaultsData.requestHistory.rawValue)
    }
    
    func deleteAllHistory() {
        defaults.set([], forKey: UserDefaultsData.requestHistory.rawValue)
    }
    
    func saveAllCategories(_ categories: [Categories]) {
        guard let encoded = try? encoder.encode(categories) else { return }
        defaults.set(encoded, forKey: UserDefaultsData.allCategories.rawValue)
    }
    
    func saveSearchHistory(_ text: String) {
        var historyArray = getSearchHistory()
        
        if historyArray.contains(text) {
            guard let index = historyArray.firstIndex(of: text) else { return }
            historyArray.moveToStart(index: index)
        } else {
            historyArray.insert(text, at: 0)
        }
        defaults.set(historyArray, forKey: UserDefaultsData.requestHistory.rawValue)
    }
    
    func getSearchHistory() -> [String] {
        guard let history = defaults.array(forKey: UserDefaultsData.requestHistory.rawValue) as? [String] else { return [] }
        return history
    }
    
    func getAllCategories() -> Observable<[Categories]> {
        return Observable.create { [unowned self] observer -> Disposable in
            if let savedPerson = self.defaults.object(forKey: UserDefaultsData.allCategories.rawValue) as? Data {
                if let categories = try? self.decoder.decode([Categories].self, from: savedPerson) {
                    observer.onNext(categories)
                } else {
                    observer.onError(ApiError.noData)
                }
            }
            return Disposables.create()
        }
    }
    
    func getCategoryName(byId id: Int) -> String {
        
        if allCategories.isEmpty {
            getAllCategories().asObservable()
            .subscribe(onNext: { [unowned self] categories in
                self.allCategories = categories
            }).disposed(by: disposeBag)
        }
        
        let category = allCategories.first { (category) -> Bool in
            return category.id == id
        }
        
        return category?.caption ?? ""
    }
}

class PhoneStorageAssembly: Assembly {

    func assemble(container: Container) {
        container.register(PhoneStorage.self) { r in
            return PhoneStorageImpl()
            }
            .inObjectScope(.container)
    }

}

extension Array {
    
     mutating func moveToStart( index: Int) {
        let buff = self.remove(at: index)
        self.insert(buff, at: 0)
    }
    
    
}

