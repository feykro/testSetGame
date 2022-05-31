//
//  SetGameViewController.swift
//  soloSetGame
//
//  Created by feykro on 19/05/2022.
//

import SwiftUI

class SetGameViewController: ObservableObject {
    typealias Card = SetGame.Card

    private static func createSetGame() -> SetGame {
        return SetGame()
    }

    @Published private var model = createSetGame()

    var cards: [Card] {
        return model.hand
    }

    var score: Int {
        return model.score
    }

    // MARK: UI INTENTS

    func choose(_ card: Card) {
        model.choseCard(card: card)
    }

    func drawThree() {
        model.draw(3)
    }

    func startOver() {
        model.reset()
    }
}
