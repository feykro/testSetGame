//
//  soloSetGameApp.swift
//  soloSetGame
//
//  Created by feykro on 19/05/2022.
//

import SwiftUI

@main
struct soloSetGameApp: App {
    var body: some Scene {
        WindowGroup {
            let game = SetGameViewController()
            ContentView(gameController: game)
        }
    }
}
