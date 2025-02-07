//
//  GameMove.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 2/6/25.
//


struct GameMove: Codable {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        player == .player1 ? "xmark" : "circle"
    }
}
