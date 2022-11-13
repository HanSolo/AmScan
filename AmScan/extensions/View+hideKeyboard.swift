//
//  View+hideKeyboard.swift
//  AmScan
//
//  Created by Gerrit Grunwald on 13.05.22.
//

import Foundation
import SwiftUI


extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
