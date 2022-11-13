//
//  Contact.swift
//  AmScan
//
//  Created by Gerrit Grunwald on 16.05.22.
//

import Foundation

class Contact: Identifiable, Equatable {
    let id        : UUID = UUID()
    var innerId   : String
    var firstName : String
    var lastName  : String
    var title     : String
    var company   : String
    var country   : String
    var state     : String
    var email     : String
    var phone     : String
    var isMql     : Bool
    var notes     : String
    
    
    init() {
        self.innerId   = UUID().description
        self.firstName = ""
        self.lastName  = ""
        self.title     = ""
        self.company   = ""
        self.country   = ""
        self.state     = ""
        self.email     = ""
        self.phone     = ""
        self.isMql     = false
        self.notes     = ""
    }
    
    
    public func toString() -> String {        
        return "\(firstName) \(lastName)\n\(company)\n\(email)\n\(phone)"
    }
    
    public func toCSV() -> String {
        return "\(firstName),\(lastName),\(title),\(company),\(country),\(state),\(email),\(phone),\(isMql),\(notes)"
    }
    
    static func equals(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.firstName == rhs.firstName &&
               lhs.lastName  == rhs.lastName &&
               lhs.email     == rhs.email
    }
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.innerId == rhs.innerId
    }
}
