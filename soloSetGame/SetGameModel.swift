//
//  SetGameModel.swift
//  soloSetGame
//
//  Created by feykro on 19/05/2022.
//

import Foundation
import SwiftUI

struct SetGame {
    private var gameCards: [Card]
    private(set) var deck: [Card]!
    private(set) var hand: [Card]!
    private var numberCardsTurned: Int!
    private(set) var score: Int!

    init() {
        gameCards = []
        let possibleColors: [Color] = [.red, .blue, .green]
        var i = 0
        for colorType in ColorType.allCases {
            for j in 0 ..< 3 {
                for faceType in FaceType.allCases {
                    for color in possibleColors {
                        gameCards.append(Card(
                            id: i,
                            type: faceType,
                            color: color,
                            colorType: colorType,
                            faceValue: j + 1
                        ))
                        i += 1
                    }
                }
            }
        }
        reset()
    }

    mutating func reset() {
        deck = gameCards
        hand = []
        score = 0
        numberCardsTurned = 0
        draw(15)
    }

    mutating func draw(_ nb: Int) {
        for _ in 0 ..< nb {
            // we take away a card from the deck to draw in the "hand"
            hand.append(deck.remove(at: deck.indices.randomElement()!))
        }
    }

    mutating func popingMatch() {
        hand.removeAll(where: { $0.isMatched })
    }

    mutating func choseCard(card: Card) {
        if let chosenInd = hand.firstIndex(where: { $0.id == card.id }) {
            //  case of a facedown card that we wanna flip up
            if !hand[chosenInd].isMatched, !hand[chosenInd].isFacedUp {
                if numberCardsTurned < 2 {
                    hand[chosenInd].isFacedUp = true
                    numberCardsTurned += 1
                } else if numberCardsTurned == 2 {
                    hand[chosenInd].isFacedUp = true
                    numberCardsTurned += 1
                    let matching = hand.indices.filter { hand[$0].isFacedUp && hand[$0].isMatched == false }
                    if isThereMatch(chosenIndices: matching) {
                        for indice in matching {
                            hand[indice].isMatched = true
                        }
                        score += 1
                    }
                } else {
                    hand.indices.forEach { hand[$0].isFacedUp = hand[$0].isMatched }
                    hand[chosenInd].isFacedUp = true
                    numberCardsTurned = 1
                }
                //  flipped up, matched card that we wanna make dissapear for readability since we don't need it anymore
            } else if !hand[chosenInd].isDimissed, hand[chosenInd].isMatched {
                popingMatch()
                //  flipped up, unmatched that we want to flip back down
            } else if hand[chosenInd].isFacedUp, !hand[chosenInd].isMatched, !hand[chosenInd].isDimissed {
                hand[chosenInd].isFacedUp = false
                numberCardsTurned += -1
            }
        }
    }

    private func isThereMatch(chosenIndices: [Int]) -> Bool {
        if chosenIndices.count != 3 { return false }

        let card1 = hand[chosenIndices[0]]
        let card2 = hand[chosenIndices[1]]
        let card3 = hand[chosenIndices[2]]

        if card1.faceValue == card2.faceValue || card1.faceValue == card3.faceValue || card2.faceValue == card3.faceValue {
            return false
        }

        if card1.type == card2.type || card1.type == card3.type || card2.type == card3.type {
            return false
        }

        if card1.color == card2.color || card1.color == card3.color || card2.color == card3.color {
            return false
        }

        if card1.colorType == card2.colorType || card1.colorType == card3.colorType || card2.colorType == card3.colorType {
            return false
        }

        return true
    }

    struct Card: Identifiable {
        var id: Int

        var isFacedUp = false
        var isMatched = false
        var isDimissed = false

        var type: FaceType
        var color: Color
        var colorType: ColorType
        var faceValue: Int
    }

    enum FaceType: CaseIterable {
        case rectangle, capsule, oval
    }

    enum ColorType: CaseIterable {
        case full, semiFull, edge
    }
}
