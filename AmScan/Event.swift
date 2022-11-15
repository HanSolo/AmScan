//
//  Event.swift
//  AmScan
//
//  Created by Gerrit Grunwald on 13.11.22.
//

import Foundation



struct Event : Codable, Hashable {    
    var name    : String
    var country : String
    var state   : String
    var city    : String
    
    
    init(name: String, country: String, state: String, city: String) {
        self.name    = name
        self.country = country
        self.state   = state
        self.city    = city
    }
}

struct Events: Codable {
    let events: [Event]
}
