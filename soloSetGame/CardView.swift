//
//  CardView.swift
//  soloSetGame
//
//  Created by feykro on 30/05/2022.
//

import SwiftUI

struct CardView: View {
    typealias Card = SetGame.Card
    private let card: Card

    init(_ card: Card) {
        self.card = card
    }

    var opacity: Double {
        switch card.colorType {
        case .full, .edge:
            return 1
        case .semiFull:
            return 0.3
        }
    }

    var isStroke: Bool {
        card.colorType == .edge
    }

    var shape: some View {
        let lineWidth: CGFloat = 3

        switch card.type {
        case .rectangle:
            return isStroke ? AnyView(Rectangle().strokeBorder(lineWidth: lineWidth)) : AnyView(Rectangle())
        case .capsule:
            return isStroke ? AnyView(Capsule().strokeBorder(lineWidth: lineWidth)) : AnyView(Capsule())
        case .oval:
            return isStroke ? AnyView(Ellipse().strokeBorder(lineWidth: lineWidth)) : AnyView(Ellipse())
        }
    }

    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                let cardShape = RoundedRectangle(cornerRadius: 15)
                let borderColor: Color = card.isMatched ? .green : .red
                if card.isFacedUp {
                    cardShape.fill()
                        .foregroundColor(.white)
                    cardShape.strokeBorder(lineWidth: 3, antialiased: true)
                        .foregroundColor(borderColor)
                    VStack(spacing: 10) {
                        ForEach(0 ..< card.faceValue, id: \.self) { _ in
                            shape
                                .foregroundColor(card.color)
                                .opacity(opacity)
                                .frame(width: abs(geometry.size.width * CardView.widthRatio), height: abs((geometry.size.height / 3) - 15))
                        }
                    }
                } else if card.isMatched {
                    cardShape.opacity(0)
                } else {
                    cardShape.fill().foregroundColor(.red)
                }
            }
        })
    }

    //  MARK: constants

    static let widthRatio: CGFloat = 0.75
}
