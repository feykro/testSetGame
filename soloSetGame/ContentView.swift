//
//  ContentView.swift
//  soloSetGame
//
//  Created by feykro on 19/05/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var gameViewController: SetGameViewController
    typealias Card = SetGame.Card

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: uiConstants.gridItemWidth))], spacing: 10) {
                        ForEach(gameViewController.cards) { item in
                            itemViewBuilder(item).aspectRatio(2 / 3, contentMode: .fit)
                        }
                    }
                    .padding(.horizontal)
                }
            }.padding(.top, 1)
            HStack {
                Button("Clear board") {
                    gameViewController.clear()
                }
                Spacer()
                Button("Start again !") {
                    gameViewController.startOver()
                }
                Spacer()
                Text("Score: \(gameViewController.score)")
            }.frame(minHeight: 70).padding(.horizontal)
        }
    }

    @ViewBuilder
    private func itemViewBuilder(_ card: Card) -> some View {
        if card.isDimissed {
            Rectangle().opacity(0)
        } else {
            CardView(card)
                .onTapGesture { gameViewController.choose(card) }
        }
    }

    // this might be a bit too big for readability and might need to be in its own file
    struct CardView: View {
        private let card: Card

        init(_ card: Card) {
            self.card = card
        }

        func getColor(cardColor: SetGame.CardColor) -> Color {
            switch cardColor {
            case .red:
                return Color.red
            case .green:
                return Color.green
            case .blue:
                return Color.blue
            }
        }

        func getOpacity(colorType: SetGame.ColorType) -> Double {
            switch colorType {
            case .full, .edge:
                return 1
            case .semiFull:
                return 0.3
            }
        }

        func createShape<T: InsettableShape>(shape: T, isStroke: Bool) -> some View {
            if isStroke {
                return AnyView(shape
                    .strokeBorder(lineWidth: 3, antialiased: true)
                    .frame(width: uiConstants.drawingWidth, height: uiConstants.drawingHeight))
            }
            return AnyView(shape.frame(width: uiConstants.drawingWidth, height: uiConstants.drawingHeight))
        }

        var body: some View {
            GeometryReader(content: { _ in
                ZStack {
                    let cardShape = RoundedRectangle(cornerRadius: 15)
                    let borderColor: Color = card.isMatched ? .green : .red
                    if card.isFacedUp {
                        cardShape.fill()
                            .foregroundColor(.white)
                        cardShape.strokeBorder(lineWidth: 3, antialiased: true)
                            .foregroundColor(borderColor)
                        VStack {
                            ForEach(0 ..< card.faceValue, id: \.self) { _ in
                                switch card.type {
                                case .rectangle:
                                    createShape(shape: Rectangle(), isStroke: card.colorType == .edge)
                                        .foregroundColor(getColor(cardColor: card.color))
                                        .opacity(getOpacity(colorType: card.colorType))
                                case .capsule:
                                    createShape(shape: Capsule(), isStroke: card.colorType == .edge)
                                        .foregroundColor(getColor(cardColor: card.color))
                                        .opacity(getOpacity(colorType: card.colorType))
                                case .oval:
                                    createShape(shape: Ellipse(), isStroke: card.colorType == .edge)
                                        .foregroundColor(getColor(cardColor: card.color))
                                        .opacity(getOpacity(colorType: card.colorType))
                                }
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
    }

    private enum uiConstants {
        static let gridItemWidth: CGFloat = 80
        static let drawingHeight: CGFloat = 25
        static let drawingWidth: CGFloat = 65
    }
}

// MARK: Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewController()
        ContentView(gameViewController: game)
            .previewInterfaceOrientation(.portrait)
    }
}
