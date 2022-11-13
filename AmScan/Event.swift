//
//  Event.swift
//  AmScan
//
//  Created by Gerrit Grunwald on 13.11.22.
//

import Foundation



struct Event : Codable {
    var name    : String
    var country : String
    var state   : String
    var city    : String
}

struct Events: Codable {
    let events: [Event]
}
