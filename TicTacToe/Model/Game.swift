//
//  Game.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 2/18/25.
//
struct Game: Codable, Identifiable {
    let id: String
    
    let player1ID: String
    let player2ID: String
    
    
    let player1Score: Int
    let player2Score: Int
    
    let activePlayerID: String
    let winningPlayerID: String
    
    var moves: [GameMove?]
    
    
}
