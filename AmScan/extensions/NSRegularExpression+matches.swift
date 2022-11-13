//
//  NSRegularExpression+matches.swift
//  AmScan
//
//  Created by Gerrit Grunwald on 13.06.22.
//

import Foundation

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
