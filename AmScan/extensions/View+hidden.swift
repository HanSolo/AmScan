//
//  View+hidden.swift
//  AmScan
//
//  Created by Gerrit Grunwald on 13.05.22.
//

import Foundation
import SwiftUI


extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
