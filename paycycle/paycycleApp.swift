//
//  paycycleApp.swift
//  paycycle
//
//  Created by Victor Castro on 15/12/22.
//

import SwiftUI

@main
struct paycycleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
