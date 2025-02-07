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
    
    private let winPatterns: Set<Set<Int>> = [
        [0,1,2],[3,4,5],[6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8] , [2,4,6]
    ]
    @Published private(set) var moves:[GameMove?] = Array(repeating: nil, count: 9)
    @Published private(set) var player1Score = 0
    @Published private(set) var player2Score = 0
    
    @Published private(set) var gameNotification = ""
    
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
        
        self.gameNotification = "it is \(activePlayer.name)'s move"
    }
    
    func processMove(for position: Int) {
        print(activePlayer.name)
        // it is the positionn occupaied
        if isSquareOccupaid(in: moves, for: position) { return }
        
        moves[position] = GameMove(player: activePlayer, boardIndex: position)
        
        
        // TODO: - Check for win
        if checkForWin(in: moves) {
            // show alert to user
            
            // increase the score of winner
            print("\(activePlayer.name) has won")
            
            return
        }
        // TODO: - Check for draw
        
        if checkForDraw(in: moves) {
            // show alert to user
            print("it is draw")
            return
        }
        // TODO: - Continue the game
        
        activePlayer = players.first(where: {$0 != activePlayer})!
        self.gameNotification = "it is \(activePlayer.name)'s move"
    }
    
    private func isSquareOccupaid(in moves: [GameMove?], for index: Int) -> Bool {
        moves.contains(where: { $0?.boardIndex == index })
    }
    
    private func checkForDraw(in moves: [GameMove?]) -> Bool {
        moves.compactMap { $0 }.count == 9
    }
    
    private func checkForWin(in moves: [GameMove?]) -> Bool {
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == activePlayer }
        let movesArray = playerMoves.map { $0.boardIndex }
        let playerPositions = Set(movesArray)
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {
            return true
        }
        
        return false
    }
}
