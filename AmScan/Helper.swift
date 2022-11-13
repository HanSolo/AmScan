//
//  Helper.swift
//  AmScan
//
//  Created by Gerrit Grunwald on 16.05.22.
//

import Foundation
import Contacts
import CoreData
import AudioToolbox
import CoreLocation
import MapKit


class Helper {
    private static let persistenceController = PersistenceController.shared
    
    
    public static func parse(text: String, mql: Bool, notes: String) -> Contact {
        let newContact = Contact()
        newContact.isMql = mql
        newContact.notes = notes
        
        if text.contains("BEGIN:VCARD") && text.contains("END:VCARD") { // VCARD FORMAT
            if let data = text.data(using: .utf16) {
                do {
                    let contacts = try CNContactVCardSerialization.contacts(with: data)
                    let contact  = contacts.first
                    if contact != nil {
                        newContact.firstName = String(describing: contact!.givenName)
                        newContact.lastName  = String(describing: contact!.familyName)
                        newContact.title     = String(describing: contact!.jobTitle)
                        newContact.company   = String(describing: contact!.organizationName)
                        let emailAddresses   = contact!.emailAddresses
                        newContact.email     = emailAddresses.isEmpty ? "" : String(describing: emailAddresses[0].value)
                        let phoneNumbers     = contact!.phoneNumbers
                        newContact.phone     = phoneNumbers.isEmpty ? "" : String(describing: phoneNumbers[0].value.stringValue)
                        let postalAddresses  = contact!.postalAddresses
                        newContact.country   = postalAddresses.isEmpty ? "" : String(describing: (postalAddresses[0].value).country)
                        newContact.state     = postalAddresses.isEmpty ? "" : String(describing: (postalAddresses[0].value).state)
                    }                    
                } catch {
                    print("Wrong vCard format")
                    // No VCard format
                }
            }
        } else { // OTHER FORMATS
            if (text.contains("::")) {
                let parts = text.replacingOccurrences(of: "::", with: ":").components(separatedBy: ":")
                newContact.lastName  = parts[1]
                newContact.firstName = parts[2]
                newContact.company   = parts[3]
                newContact.email     = parts[4]
            } else {
                let parts = text.replacingOccurrences(of: ", ", with: ",").split(separator: ",")
                if parts.count > 0 {
                    let nameFormatter = PersonNameComponentsFormatter()
                    for part in parts {
                        let p = String(part);
                        if p.contains("@") && newContact.email.isEmpty {
                            newContact.email = p
                        } else if let nameComps = nameFormatter.personNameComponents(from: p) {
                            if newContact.firstName.isEmpty || newContact.lastName.isEmpty {
                                if newContact.firstName.isEmpty {
                                    newContact.firstName = nameComps.givenName ?? ""
                                }
                                if newContact.lastName.isEmpty {
                                    newContact.lastName = nameComps.familyName ?? ""
                                }
                            } else {
                                if !p.contains("@") && newContact.company.isEmpty {
                                    newContact.company = p
                                }
                            }
                        }
                    }
                }
            }
        }
        return newContact
    }
    
    public static func createContactEntity(contact: Contact) -> ContactEntity {
        let contactEntity = ContactEntity(context: persistenceController.container.viewContext)
        contactEntity.firstName = contact.firstName
        contactEntity.lastName  = contact.lastName
        contactEntity.title     = contact.title
        contactEntity.company   = contact.company
        contactEntity.country   = contact.country
        contactEntity.state     = contact.state
        contactEntity.email     = contact.email
        contactEntity.phone     = contact.phone
        contactEntity.mql       = contact.isMql
        contactEntity.notes     = contact.notes
        return contactEntity
    }
    
    public static func createContact(contactEntity: ContactEntity) -> Contact {
        let contact = Contact()
        contact.firstName = contactEntity.firstName ?? ""
        contact.lastName  = contactEntity.lastName  ?? ""
        contact.title     = contactEntity.title     ?? ""
        contact.company   = contactEntity.company   ?? ""
        contact.country   = contactEntity.country   ?? ""
        contact.state     = contactEntity.state     ?? ""
        contact.email     = contactEntity.email     ?? ""
        contact.phone     = contactEntity.phone     ?? ""
        contact.isMql     = contactEntity.mql
        contact.notes     = contactEntity.notes     ?? ""
        return contact
    }
    
    public static func saveContactEntity(contactEntity: ContactEntity) {
        if persistenceController.container.viewContext.hasChanges {
            do {
                try persistenceController.container.viewContext.save()
            } catch {
                
            }
        }
    }
    
    public static func deleteContactEntity(contactEntity: ContactEntity) -> Void {
        persistenceController.container.viewContext.delete(contactEntity)
        do {
            try persistenceController.container.viewContext.save()
        } catch {
            
        }
    }
    
    public static func getAllContactEntities() -> [ContactEntity] {
        let fetchRequest: NSFetchRequest<ContactEntity>
        fetchRequest = ContactEntity.fetchRequest()
        var entities: [ContactEntity] = []
        do {
            entities = try persistenceController.container.viewContext.fetch(fetchRequest)
        } catch {
            print("Error getting all entities")
        }
        return entities
    }
    
    public static func removeAllContactEntities() -> Void {
        let entities = getAllContactEntities()
        for entity in entities {
            deleteContactEntity(contactEntity: entity)
        }
    }
    
    public static func getAllContacts() -> [Contact] {
        let contactEntities : [ContactEntity] = getAllContactEntities()
        var contacts        : [Contact]       = []
        for contactEntity in contactEntities {
            contacts.append(Helper.createContact(contactEntity: contactEntity))
        }
        return contacts
    }
    
    public static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    public static func getCurrentCountry(lat: Double, lon: Double) -> Constants.Country {
        let geoCoder = CLGeocoder();
        let location = CLLocation(latitude: lat, longitude: lon)
        var isoCode  = "Unknown"
        
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print(error)
            }
            guard let placemark = placemarks?.last else { return }
            isoCode = placemark.isoCountryCode ?? "Unknown"
        }
        return Constants.Country(rawValue: isoCode) ?? Constants.Country.NN
    }
    
    
    public static func getEvents() -> [Event] {
        let jsonData = Helper.readLocalFile(forName: "events")
        if let data = jsonData {
            if let eventsObj = Helper.parse(jsonData: data) {
                return eventsObj.events
            } else {
                return []
            }
        } else {
            print("error reading json file")
            return []
        }
    }

    public static func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    public static func loadJson(fromURLString urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }
            urlSession.resume()
        }
    }
    
    public static func parse(jsonData: Data) -> Events? {
        do {
            let decodedData = try JSONDecoder().decode(Events.self, from: jsonData)
            return decodedData
        } catch {
            print("error: \(error)")
        }
        return nil
    }
}
