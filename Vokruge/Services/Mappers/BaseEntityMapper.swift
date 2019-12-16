//
//  BaseEntityMapper.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 09.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import Foundation

class EntityMapper<S, L> {
    func toLocal(list: [S]) -> [L?] {
        return list.map { entity -> L? in
            return toLocal(serverEntity: entity)
        }
    }

    func toLocal(serverEntity: S) -> L? {
        preconditionFailure("This method must be overriden")
    }

}

func mapNotNull<T>(_ array: [T?]) -> [T] {
    return array.compactMap { $0 }
}
