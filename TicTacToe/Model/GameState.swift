//
//  GameState.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 2/7/25.
//


enum GameState {
    case finished
    case draw
    case waitingForPlayer
    case quit
    
    var name: String {
        switch self {
            case .finished:
                return AppString.gameHasFinished
            case .draw:
                return AppString.draw
            case .waitingForPlayer:
                return AppString.waitingForPlayer
            case .quit:
                return AppString.playerLeft
                
        }
    }
}
