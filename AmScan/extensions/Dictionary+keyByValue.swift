//
//  Dictionary+keyByValue.swift
//  AmScan
//
//  Created by Gerrit Grunwald on 09.06.22.
//

import Foundation

extension Dictionary where Value: Equatable {
    func key(from value: Value) -> Key? {
        return self.first(where: { $0.value == value })?.key
    }
}
