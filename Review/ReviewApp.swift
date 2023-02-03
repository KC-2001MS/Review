//
//  ReviewApp.swift
//  Review
//
//  Created by 茅根啓介 on 2023/02/03.
//

import SwiftUI

@main
struct ReviewApp: App {
    @StateObject var setting = SettingObject()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(setting)
        }
    }
}
