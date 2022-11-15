//
//  MailView.swift
//  AmScan
//
//  Created by Gerrit Grunwald on 18.05.22.
//

import Foundation
import SwiftUI
import MessageUI


struct MailView: UIViewControllerRepresentable {

    @Binding var isShowing: Bool
    @Binding var result   : Result<MFMailComposeResult, Error>?

    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var isShowing: Bool
        @Binding var result   : Result<MFMailComposeResult, Error>?

        init(isShowing: Binding<Bool>, result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result    = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing, result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let entities = Helper.getAllContactEntities()
        var csv : String = "First Name,Last Name,Title,Company,Country,State,Mail,Phone,MQL,Notes,EventName,EventCountry,EventState,EventCity\n"
        for entity in entities {
            let contact = Helper.createContact(contactEntity: entity)
            csv += contact.firstName
            csv += ","
            csv += contact.lastName
            csv += ","
            csv += contact.title
            csv += ","
            csv += contact.company
            csv += ","
            csv += contact.country
            csv += ","
            csv += contact.state
            csv += ","
            csv += contact.email
            csv += ","
            csv += contact.phone
            csv += ","
            csv += contact.isMql.description
            csv += ","
            csv += contact.notes
            csv += ","
            csv += contact.eventName
            csv += ","
            csv += contact.eventCountry
            csv += ","
            csv += contact.eventState
            csv += ","
            csv += contact.eventCity
            csv += "\n"
        }
        let data = csv.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setSubject("AmScan leads")
        vc.setMessageBody("Scanned leads as csv file", isHTML: false)
        //vc.setMessageBody(csv, isHTML: false)
        vc.addAttachmentData(data!, mimeType: "text/csv", fileName: "leads.csv")
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,context: UIViewControllerRepresentableContext<MailView>) {

    }
}
