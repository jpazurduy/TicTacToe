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
    
    
    var player1Score: Int
    var player2Score: Int
    
    var activePlayerID: String
    var winningPlayerID: String
    
    var moves: [GameMove?]
    
    
}
