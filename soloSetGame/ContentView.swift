//
//  ContentView.swift
//  soloSetGame
//
//  Created by feykro on 19/05/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var gameController: SetGameViewModel
    typealias Card = SetGame.Card
    let columns: [GridItem] = [.init(.flexible(minimum: 65)),
                               .init(.flexible(minimum: 65)),
                               .init(.flexible(minimum: 65)),
                               .init(.flexible(minimum: 65))]

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(gameController.cards) { item in
                            itemViewBuilder(item).aspectRatio(2 / 3, contentMode: .fit)
                        }
                    }
                    .padding(.horizontal)
                }
            }.padding(.top, 1)
            HStack {
                Button("Draw 3") {
                    gameController.drawThree()
                }
                Spacer()
                Button("Start again !") {
                    gameController.startOver()
                }
                Spacer()
                Text("Score: \(gameController.score)")
            }.padding(EdgeInsets(top: 20, leading: 15, bottom: 20, trailing: 15))
        }
    }

    @ViewBuilder
    private func itemViewBuilder(_ card: Card) -> some View {
        if card.isDimissed {
            Rectangle().opacity(0)
        } else {
            CardView(card)
                .onTapGesture { gameController.choose(card) }
        }
    }
}

// MARK: Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        ContentView(gameController: game)
            .previewInterfaceOrientation(.portrait)
    }
}
