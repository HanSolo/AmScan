//
//  AmScanApp.swift
//  AmScan
//
//  Created by Gerrit Grunwald on 09.05.22.
//

import SwiftUI

@main
struct AmScanApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
