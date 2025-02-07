//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 1/24/25.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let colums: [GridItem] = [ GridItem(.flexible()),
                                  GridItem(.flexible()),
                                  GridItem(.flexible())
                                ]
    
    
    @Published private(set) var player1Score = 0
    @Published private(set) var player2Score = 0
    
    @Published private(set) var player1Name = ""
    @Published private(set) var player2Name = ""
    
    @Published private(set) var activePlayer: Player = .player1
    
    @Published var gameMode: GameMode
    @Published private var players: [Player] = []
    
    
    init(gameMode: GameMode) {
        self.gameMode = gameMode
        
        switch gameMode {
            case .vsCPU:
                self.players = [.player1, .cpu]
            case .vsHuman:
                self.players = [.player1, .player2]
            case .vsOnline:
                self.players = [.player1, .player2]
        }
    }
}
