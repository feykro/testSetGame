//
//  SetGameModel.swift
//  soloSetGame
//
//  Created by feykro on 19/05/2022.
//

import Foundation

struct SetGame {
    private(set) var cards: [Card]!
    private var numberCardsTurned: Int!
    private(set) var score: Int!

    init() {
        reset()
    }

    mutating func reset() {
        cards = []
        score = 0
        numberCardsTurned = 0
        var i = 0
        for colorType in ColorType.allCases {
            for j in 0 ..< 3 {
                for faceType in FaceType.allCases {
                    for color in CardColor.allCases {
                        cards.append(Card(
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
        cards.shuffle()
    }

    mutating func choseCard(card: Card) {
        if let chosenInd = cards.firstIndex(where: { $0.id == card.id }) {
            //  case of a facedown card that we wanna flip up
            if !cards[chosenInd].isMatched, !cards[chosenInd].isFacedUp {
                if numberCardsTurned < 2 {
                    cards[chosenInd].isFacedUp = true
                    numberCardsTurned += 1
                } else if numberCardsTurned == 2 {
                    cards[chosenInd].isFacedUp = true
                    numberCardsTurned += 1
                    let matching = cards.indices.filter { cards[$0].isFacedUp && cards[$0].isMatched == false }
                    if isThereMatch(chosenIndices: matching) {
                        for indice in matching {
                            cards[indice].isMatched = true
                        }
                        score += 1
                    }
                } else {
                    cards.indices.forEach { cards[$0].isFacedUp = cards[$0].isMatched }
                    cards[chosenInd].isFacedUp = true
                    numberCardsTurned = 1
                }
                //  flipped up, matched card that we wanna make dissapear for readability since we don't need it anymore
            } else if !cards[chosenInd].isDimissed, cards[chosenInd].isMatched {
                let matching = cards.indices.filter { cards[$0].isMatched }
                for indice in matching {
                    cards[indice].isDimissed = true
                }
                //  flipped up, unmatched that we want to flip back down
            } else if cards[chosenInd].isFacedUp, !cards[chosenInd].isMatched, !cards[chosenInd].isDimissed {
                cards[chosenInd].isFacedUp = false
                numberCardsTurned += -1
            }
        }
    }

    mutating func popingMatch() {
        cards.removeAll(where: { $0.isMatched })
    }

    private func isThereMatch(chosenIndices: [Int]) -> Bool {
        if chosenIndices.count != 3 { return false }

        let card1 = cards[chosenIndices[0]]
        let card2 = cards[chosenIndices[1]]
        let card3 = cards[chosenIndices[2]]

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
        var color: CardColor
        var colorType: ColorType
        var faceValue: Int
    }

    enum FaceType: CaseIterable {
        case rectangle, capsule, oval
    }

    enum ColorType: CaseIterable {
        case full, semiFull, edge
    }

    enum CardColor: CaseIterable {
        case blue, green, red
    }
}
