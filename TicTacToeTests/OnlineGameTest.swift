//
//  OnlineGameTest.swift
//  TicTacToeTests
//
//  Created by Jorge Azurduy on 4/4/25.
//

import Testing
import Factory
import Foundation
import Combine

@testable import TicTacToe

struct OnlineGameTest {

    private var cancellables: Set<AnyCancellable> = []
    
    
    @Test mutating func joinGameReturnAGame() async throws {
        Container.setupMocks()
        let sut = OnlineGameRepository()
        
        sut.$game
            .dropFirst()
            .sink { game in
                #expect(game?.id == "MOCK")
                #expect(game?.player1ID == "Play 1")
            }
            .store(in: &cancellables)
        
        await sut.joinGame()
    }
    
    @Test mutating func joinGameCreateAGame() async throws {
        Container.setupMocks(shouldReturNil: true)
        let sut = OnlineGameRepository()
        
        sut.$game
            .dropFirst()
            .sink { game in
                #expect(game?.id == "MOCK")
                #expect(game?.player2ID == "")
            }
            .store(in: &cancellables)
        
        await sut.joinGame()
    }

}
