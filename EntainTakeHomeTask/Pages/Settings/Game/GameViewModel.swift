//
//  GameViewModel.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/27.
//

import Foundation
import SwiftUI
import Combine

struct Score {
    let player1: Int
    let player2: Int
}


final class GameViewModel: ObservableObject {
    @Published var score: Score
    @Published var finalWinner: String? = nil
    // This is mock data, should use the real one
    private var finalScores = [Score(player1: 0, player2: 1),
                               Score(player1: 2, player2: 1),
                               Score(player1: 3, player2: 2),
                               Score(player1: 0, player2: 3),
                               Score(player1: 4, player2: 1)]
    private var playerPointSubject = PassthroughSubject<Int,Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    
    internal init(score: Score) {
        self.score = score
        
        playerPointSubject
            .scan(Score(player1: 0, player2: 0)) { [weak self] currentScore, whichPlayer in
                guard let self else { return Score(player1: 0, player2: 0)
                }
                self.score = self.updateScore(whichPlayer: whichPlayer)
                return self.score
            }
            .sink { value in
                print("Scan: the value is \(value)")
            }
            .store(in: &cancelBag)
    }
    
    
    func score(whichPlayer: Int) {
        playerPointSubject.send(whichPlayer)
    }
    
    private func updateScore(whichPlayer: Int) -> Score {
        if whichPlayer == 1 {
            return Score(player1: score.player1 + 1,
                         player2: score.player2)
        } else if whichPlayer == 2 {
            return Score(player1: score.player1,
                         player2: score.player2 + 1)
        } else {
            fatalError()
        }
    }
    
    func finishGame() {
        finalScores
            .publisher
            .reduce(0) { currentValue, score in
                if score.player1 > score.player2 {
                    currentValue + 1
                } else if score.player1 < score.player2 {
                    currentValue - 1
                } else {
                    currentValue
                }
            }
            .map({ finalWinner in
                if finalWinner > 0 {
                    return "Player 1 Won!"
                } else if finalWinner < 0 {
                    return "Player 2 Won!"
                } else {
                    return "Deuce!"
                }
            })
            .sink { [weak self] value in
                print("REDUCE: the value is \(value)")
                self?.finalWinner = value
            }
            .store(in: &cancelBag)
    }
}
