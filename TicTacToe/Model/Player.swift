//
//  Player.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 1/29/25.
//

enum Player: Codable {
    case player1, player2, cpu
    
    var name: String {
        switch self {
            case .player1:
                return AppString.player1
            case .player2:
                return AppString.player2
            case .cpu:
                return AppString.cpu
        }
    }
}
