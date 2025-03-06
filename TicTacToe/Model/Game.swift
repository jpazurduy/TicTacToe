//
//  Game.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 2/18/25.
//
struct Game: Codable, Identifiable {
    let id: String
    
    var player1ID: String
    var player2ID: String
    
    
    let player1Score: Int
    let player2Score: Int
    
    var activePlayerID: String
    let winningPlayerID: String
    
    var moves: [GameMove?]
    
    
}
