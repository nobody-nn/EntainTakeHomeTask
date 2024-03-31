//
//  GameView.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/27.
//

import SwiftUI

struct GameView: View {
    @StateObject var gameViewModel = GameViewModel(score: Score(player1: 0, player2: 0))
    
    var body: some View {
        VStack {
            Text("Player 1 Score: \(gameViewModel.score.player1)")
                .font(.title)
            Text("Player 2 Score: \(gameViewModel.score.player2)")
                .font(.title)
            HStack {
                Button("Random Player Scores") {
                    gameViewModel.score(whichPlayer: Int.random(in: 1...2))
                }
                
                Button("Finish Game") {
                    gameViewModel.finishGame()
                }
            }.buttonStyle(.borderedProminent)
            
            
            if let finalWinner = gameViewModel.finalWinner {
                Text("\(finalWinner)")
            } else {
                Text("Wait for the final Winner")
            }
        }
        .padding()
    }
}

#Preview {
    GameView()
}
