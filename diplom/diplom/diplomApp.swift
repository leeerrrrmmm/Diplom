//
//  diplomApp.swift
//  diplom
//
//  Created by .Leeerrrmmm . on 08.05.2025.
//

import SwiftUI

@main
struct diplomApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
