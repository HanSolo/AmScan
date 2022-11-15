//
//  ScannerView.swift
//  AmScan
//
//  Created by Gerrit Grunwald on 09.05.22.
//

import Combine
import SwiftUI
import Speech
import MessageUI
import CoreData
import Contacts
import MapKit
//import os.log


struct ScannerView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var viewModel : ScannerViewModel                 = ScannerViewModel()
    @StateObject var recognizer                                   = Recognizer()
    @State       var mailViewVisible                              = false
    @State       var result : Result<MFMailComposeResult, Error>? = nil
    @State       var showContacts                                 = false
                 var qrScannerView                                = QrCodeScannerView()
    @State       var showingAlert                                 = false
    @State       var events : [Event]                             = []
    
    
    var body: some View {

        ZStack {
            VStack {
                VStack {
                    HStack {

                        if MFMailComposeViewController.canSendMail() {
                            Button(action: {
                                self.mailViewVisible.toggle()
                            }, label: {
                                VStack(alignment: .center) {
                                    Image(systemName: "square.and.arrow.up")
                                        .resizable()
                                        .frame(width: 16, height: 20, alignment: .center)
                                        .foregroundColor(self.viewModel.numberOfContacts == 0 ? Color.gray : Color.blue)
                                }
                                .padding()
                            })
                            .sheet(isPresented: $mailViewVisible) {
                                MailView(isShowing: self.$mailViewVisible, result: self.$result)
                            }
                            .background(Color.clear)
                            .cornerRadius(10)
                            .disabled(self.viewModel.numberOfContacts == 0)
                        }

                        Spacer()
                                         
                        Button("AmScan (\(self.viewModel.numberOfContacts))") {
                            self.showContacts = true
                        }
                        .font(.title2)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .accentColor(self.viewModel.numberOfContacts == 0 ? Color.gray : Color.blue)
                        .disabled(self.viewModel.numberOfContacts == 0)
                        .sheet(isPresented: $showContacts, onDismiss: {}) {
                            ContactsView()
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showingAlert = true
                        }, label: {
                            VStack(alignment: .center) {
                                Image(systemName: "trash")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .foregroundColor(self.viewModel.numberOfContacts == 0 ? Color.gray : Color.blue)
                            }
                            .padding()
                        })
                        .background(Color.clear)
                        .cornerRadius(10)
                        .disabled(self.viewModel.numberOfContacts == 0)
                        .alert(isPresented:$showingAlert) {
                            Alert(
                                title  : Text("Delete all scanned leads?"),
                                message: Text("There is no undo"),
                                primaryButton: .destructive(Text("Delete")) {
                                    Helper.removeAllContactEntities()
                                    self.viewModel.contactMap.removeAll()
                                    self.viewModel.numberOfContacts = 0
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                }
                
                self.qrScannerView
                    .found(r: self.viewModel.onFoundQrCode)
                    .torchLight(isOn: self.viewModel.isLightOn)
                    .interval(delay: self.viewModel.scanInterval)
                    .frame(height:200)
                    .cornerRadius(10.0)
                    //.padding([.bottom])
                    .overlay(
                        ZStack {
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(self.colorScheme == .dark ? Color(UIColor.darkGray) : Color(UIColor.lightGray), lineWidth: 1.0)
                                .background(self.viewModel.isScanning ? Color.clear : self.colorScheme == .dark ? Color.black : Color.white)
                            Text("Scan View")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.system(size: 20))
                                .foregroundColor(Color.gray)
                                .hidden(self.viewModel.isScanning)
                        }
                    )
                    .cornerRadius(10.0)
                
                VStack {
                    ZStack(alignment: .leading) {
                        if self.viewModel.scannedResult.isEmpty {
                            Text("QR Code text")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.system(size: 20))
                                .foregroundColor(Color.gray)
                        }
                        TextEditor(text: Binding(get: { self.viewModel.scannedResult }, set: { self.viewModel.scannedResult = $0 }))
                            .font(.system(.body))
                            .frame(minHeight: 60, idealHeight: 120, maxHeight: 180)
                            .cornerRadius(10.0)
                            .font(.system(size: 10))
                            .padding([.top, .trailing, .leading])
                            .opacity(self.viewModel.scannedResult.isEmpty ? 0.25 : 1.0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(self.colorScheme == .dark ? Color(UIColor.darkGray) : Color(UIColor.lightGray), lineWidth: 1.0)
                            )
                            .disabled(self.viewModel.scannedResult.isEmpty)
                    }
                    
                    ZStack(alignment: .leading) {
                        if self.viewModel.notes.isEmpty {
                            Text("Notes")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.system(size: 20))
                                .foregroundColor(Color.gray)
                        }
                        TextEditor(text: Binding(get: { self.viewModel.notes }, set: { self.viewModel.notes = $0 }))
                            .font(.system(.body))
                            .frame(minHeight: 40, idealHeight: 100, maxHeight: 180)
                            .cornerRadius(10.0)
                            .padding([.trailing, .leading])
                            .opacity(self.viewModel.notes.isEmpty ? 0.25 : 1)
                            .disabled(self.viewModel.scannedResult.isEmpty)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(self.colorScheme == .dark ? Color(UIColor.darkGray) : Color(UIColor.lightGray), lineWidth: 1.0)
                            )
                    }
                                                    
                    Button(action: {
                        hideKeyboard()
                    }, label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                            .imageScale(.medium)
                            .foregroundColor(Color.blue)
                    })
                    .padding([.top, .leading, .trailing])
                     
                    
                    VStack {
                        Menu {
                            Picker(selection: $viewModel.selectedEvent) {
                                ForEach(events, id: \.self) {
                                    Text($0.name)
                                        .tag($0.name)
                                        .font(.system(size: 10))
                                }
                            } label: {}
                            
                        } label: {
                            Text(viewModel.selectedEvent.name)
                                .font(.system(size: 16))
                        }
                        .id(viewModel.selectedEvent)
                        .padding([.top, .bottom])
                    }
                    
                    HStack {
                        Button(action: {
                            self.viewModel.isLightOn.toggle()
                        }, label: {
                            VStack(alignment: .center) {
                                Text("Light")
                                Image(systemName: self.viewModel.isLightOn ? "lightbulb.fill" : "lightbulb.slash")
                                    .imageScale(.large)
                            }
                            .padding()
                        })
                        .foregroundColor(.accentColor)
                        
                        Spacer()
                        
                        Button(action: {
                            if self.viewModel.isScanning {
                                qrScannerView.stopScanning()
                            } else {
                                qrScannerView.startScanning()
                            }
                            self.viewModel.isScanning.toggle()
                        }, label: {
                            VStack(alignment: .center) {
                                Text("Scan")
                                Image(systemName: self.viewModel.isScanning ? "qrcode.viewfinder" : "viewfinder")
                                    .imageScale(.large)
                            }
                            .foregroundColor(.accentColor)
                            .padding()
                        })
                        .foregroundColor(.accentColor)
                        
                        Spacer()
                        
                        Button(action: {
                            self.viewModel.isRecording.toggle()
                            if self.viewModel.isRecording {
                                self.viewModel.notes = ""
                                recognizer.startSpeechRecognization()
                            } else {
                                recognizer.cancelSpeechRecognization()
                                self.viewModel.notes = recognizer.transcript
                            }
                        }, label: {
                            VStack(alignment: .center) {
                                Text("Note")
                                Image(systemName: self.viewModel.isRecording ? "mic.fill" : "mic.slash.fill")
                                    .imageScale(.large)
                            }
                            .padding()
                        })
                        .foregroundColor(.accentColor)
                        .disabled(self.viewModel.scannedResult.isEmpty)
                        
                        Spacer()
                        
                        Button(action: {
                            self.viewModel.isMQL.toggle()
                        }, label: {
                            VStack(alignment: .center) {
                                Text("MQL")
                                Image(systemName: self.viewModel.isMQL ? "checkmark.square" : "square")
                                    .imageScale(.large)
                            }
                            .padding()
                        })
                        .foregroundColor(.accentColor)
                        .disabled(self.viewModel.scannedResult.isEmpty)
                    }
                    
                    HStack {
                        
                        Button(action: {
                            self.viewModel.reset()
                        }, label: {
                            VStack(alignment: .center) {
                                Text("Cancel")
                            }
                            .padding()
                        })
                        .accentColor(.blue)
                        .disabled(self.viewModel.scannedResult.isEmpty)
                                            
                        Spacer()
                        
                        Link(destination: URL(string: "https://github.com/HanSolo/AmScan/wiki")!) {
                            Image(systemName: "info.circle")
                                .font(.title2)
                        }
                         
                        Spacer()
                        
                        Button(action: {                            
                            self.viewModel.save()
                            self.viewModel.isScanning = false
                            self.qrScannerView.stopScanning()
                        }, label: {
                            VStack(alignment: .center) {
                                Text("Save")
                            }
                            .padding()
                        })
                        .accentColor(.blue)
                        .disabled(self.viewModel.scannedResult.isEmpty)
                    }
                    
                }
                .cornerRadius(10)
                
            }.padding()
        }
        .environmentObject(viewModel)
        .alert("Contact already scanned", isPresented: $viewModel.showExistsAlert) {
            Button("OK", role: .cancel) {}
        }
        .onAppear(perform: fetchEvents)
        
    }
    
    private func fetchEvents() {
        Task.init {
            //self.events = (await Helper.getEventsAsync()).sorted(by: { $0.name < $1.name }) // sorted alphabetically
            self.events = (await Helper.getEventsAsync()).sorted(by: { $1.name < $0.name }) // sorted alphabetically reversed
        }
    }
    
}



struct ContactRow: View {
    @EnvironmentObject var viewModel : ScannerViewModel
    
    var contact: Contact
    
    @State private var firstName   : String
    @State private var lastName    : String
    @State private var title       : String
    @State private var company     : String
    @State private var email       : String
    @State private var phone       : String
    @State private var country     : String
    @State private var state       : String
    @State private var notes       : String
    @State private var isMql       : Bool
    @State private var eventName   : String
    @State private var eventCountry: String
    @State private var eventState  : String
    @State private var eventCity   : String
    @State private var showingAlert: Bool = false
    
    
    init(contact: Contact) {
        self.contact      = contact
        self.firstName    = contact.firstName
        self.lastName     = contact.lastName
        self.title        = contact.title
        self.company      = contact.company
        self.email        = contact.email
        self.phone        = contact.phone
        self.country      = contact.country
        self.state        = contact.state
        self.notes        = contact.notes
        self.isMql        = contact.isMql
        self.eventName    = contact.eventName
        self.eventCountry = contact.eventCountry
        self.eventState   = contact.eventState
        self.eventCity    = contact.eventCity
    }
    
    
    var body: some View {
        VStack {
            Group {
                TextField("First name:", text: $firstName)
                TextField("Last  name:", text: $lastName)
                TextField("Title:", text: $title)
                TextField("Company:", text: $company)
                TextField("e-mail:", text: $email)
                TextField("Phone:", text: $phone)
                TextField("Country:", text: $country)
                TextField("State:", text: $state)
                
                ZStack(alignment: .topLeading) {
                    if notes.isEmpty {
                        Text("Notes:")
                            .foregroundColor(Color(UIColor.placeholderText))
                    }
                    TextEditor(text: $notes)
                        .padding(.horizontal, -4)
                        .padding(.vertical, -6)
                }
                    
                Toggle("MQL:", isOn: $isMql)
                    .padding(.vertical, 4)                
            }
            HStack {
                Button("Delete") {
                    showingAlert = true
                }
                .alert(isPresented:$showingAlert) {
                    Alert(
                        title  : Text("Delete lead"),
                        message: Text("There is no undo"),
                        primaryButton: .destructive(Text("Delete")) {
                            // Remove contact here
                            Helper.removeAllContactEntities()
                            self.viewModel.deleteContact(contact: contact)
                        },
                        secondaryButton: .cancel()
                    )
                }
                Spacer()
                Button("Save") {
                    // Save contact here
                    let changedContact = Contact()
                    changedContact.innerId      = contact.innerId
                    changedContact.firstName    = $firstName.wrappedValue
                    changedContact.lastName     = $lastName.wrappedValue
                    changedContact.title        = $title.wrappedValue
                    changedContact.company      = $company.wrappedValue
                    changedContact.email        = $email.wrappedValue
                    changedContact.phone        = $phone.wrappedValue
                    changedContact.country      = $country.wrappedValue
                    changedContact.state        = $state.wrappedValue
                    changedContact.notes        = $notes.wrappedValue
                    changedContact.isMql        = $isMql.wrappedValue
                    changedContact.eventName    = $eventName.wrappedValue
                    changedContact.eventCountry = $eventCountry.wrappedValue
                    changedContact.eventState   = $eventState.wrappedValue
                    changedContact.eventCity    = $eventCity.wrappedValue
                    self.viewModel.upsertContact(contact: changedContact)
                }
                .buttonStyle(BorderlessButtonStyle())
            }.padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
        }
        .environmentObject(viewModel)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
        //Spacer()
    }
}

struct ContactsView: View {
    @Environment(\.presentationMode) var presentation
    
    @EnvironmentObject var viewModel : ScannerViewModel
    
    var body: some View {
        VStack {
            List(Array(viewModel.contactMap.values)) { contact in
                ContactRow(contact: contact)
            }
            Button("Close") {
                self.presentation.wrappedValue.dismiss()
            }.padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
        }
        .environmentObject(viewModel)
    }
}
