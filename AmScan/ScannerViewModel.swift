//
//  ScannerViewModel.swift
//  AmScan
//
//  Created by Gerrit Grunwald on 09.05.22.
//

import Foundation
import AVKit
import SwiftUI


class ScannerViewModel: ObservableObject {
    
    /// Defines how often we are going to try looking for a new QR-code in the camera feed.
    let scanInterval: Double = 1.0
    
    @Published var isLightOn       : Bool                    = false {
        didSet {
            guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
                guard device.hasTorch else { return }
                do {
                    try device.lockForConfiguration()

                    if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                        device.torchMode = AVCaptureDevice.TorchMode.off
                    } else {
                        do {
                            try device.setTorchModeOn(level: 1.0)
                        } catch {
                            print(error)
                        }
                    }
                    device.unlockForConfiguration()
                } catch {
                    print(error)
                }                
        }
    }
    @Published var isRecording     : Bool                    = false
    @Published var isMQL           : Bool                    = false
    @Published var notes           : String                  = ""
    @Published var scannedResult   : String                  = ""
    @Published var code            : String                  = ""
    @Published var isScanning      : Bool                    = false
    @Published var contactMap      : [ContactEntity:Contact] = [:]
    @Published var numberOfContacts: Int                     = 0
    @Published var showExistsAlert : Bool                    = false
    
    
    init() {
        let entities = Helper.getAllContactEntities()
        for entity in entities {
            contactMap[entity] = Helper.createContact(contactEntity: entity)
        }
        self.numberOfContacts  = self.contactMap.count
    }
    
    
    func onFoundQrCode(_ code: String) {
        let contact = Helper.parse(text: code, mql: isMQL, notes: notes)
        for existingContact in self.contactMap.values {
            if Contact.equals(lhs: contact, rhs: existingContact) {
                self.isScanning      = false
                self.showExistsAlert = true
                return
            }
        }
        self.code          = code
        self.scannedResult = contact.toString()
        Helper.vibrate()
    }
    
    func upsertContact(contact: Contact) {
        var success = false
        for entity in self.contactMap.keys {
            let existingContact = self.contactMap[entity]
            if existingContact == contact {
                self.contactMap.updateValue(contact, forKey: entity)
                entity.firstName = contact.firstName
                entity.lastName  = contact.lastName
                entity.title     = contact.title
                entity.company   = contact.company
                entity.email     = contact.email
                entity.phone     = contact.phone
                entity.country   = contact.country
                entity.state     = contact.state
                entity.notes     = contact.notes
                entity.mql       = contact.isMql
                Helper.saveContactEntity(contactEntity: entity)
                success = true
                break
            }
        }
        if success {
            return
        } else {
            let entity = Helper.createContactEntity(contact: contact)
            self.contactMap[entity] = contact
            self.numberOfContacts   = self.contactMap.count
            Helper.saveContactEntity(contactEntity: entity)
        }
    }
    
    func deleteContact(contact: Contact) {
        if let key = contactMap.key(from: contact) {
            self.contactMap.removeValue(forKey: key)
            self.numberOfContacts = self.contactMap.count
            Helper.deleteContactEntity(contactEntity: key)
        }
    }
    
    /**
        Called from save button in main screen.
        Only used to persist the data from the last scan
     */
    func save() {
        let contact = Helper.parse(text: self.code, mql: self.isMQL, notes: self.notes)
        let entity  = Helper.createContactEntity(contact: contact)
        Helper.saveContactEntity(contactEntity: entity)
        
        self.contactMap[entity] = contact
        self.numberOfContacts   = self.contactMap.count
        
        reset()
    }
    
    func reset() {
        self.isRecording   = false
        self.isMQL         = false
        self.notes         = ""
        self.code          = ""
        self.scannedResult = ""
        self.isScanning    = false
    }
}
