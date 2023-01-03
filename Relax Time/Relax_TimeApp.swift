//
//  Relax_TimeApp.swift
//  Relax Time
//
//  Created by Mykola Omelianov on 03.01.2023.
//

import SwiftUI

@main
struct Relax_TimeApp: App {
    let nCenter = NotificationScheduller()
    @State private var currentNumber: String = "off"
    @State private var repeated = false
    
    var body: some Scene {
        MenuBarExtra(currentNumber, systemImage: "power\(currentNumber)") {
            Button("turn off") {
                currentNumber = "off"
            }.keyboardShortcut("1")
                .tint(.red)
            Button("turn on") {
                currentNumber = "on"
                nCenter.setRepeated(repeating: repeated)
                nCenter.turnOnNotification()
            }.keyboardShortcut("2")
            Divider()
            Toggle("repeat", isOn: $repeated)
            Divider()
            Text("Set time:")
            Button("30m") {
                nCenter.setTime(time: 30*60)
            }.keyboardShortcut("3")
            Button("15m") {
                nCenter.setTime(time: 15*60)
            }.keyboardShortcut("5")
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        }
    }
    
        
}


