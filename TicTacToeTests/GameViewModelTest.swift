//
//  GameViewModelTest.swift
//  TicTacToeTests
//
//  Created by Jorge Azurduy on 4/2/25.
//

import Foundation
import Testing
@testable import TicTacToe

extension Tag {
    @Tag static var critical: Self
    @Tag static var common: Self
    @Tag static var functional: Self
}

struct GameViewModelTest {

    var sut = GameViewModel(gameMode: .vsHuman, onlineRepositrory: OnlineGameRepository())
    
    @Test(arguments: ["Argument 1","Argument 2","Argument 3"])
    func testResetwithParameter(name: String) {
        print(name)
        sut.resetGame()
        #expect(sut.activePlayer == .player1)
    }
    
    @Test("Reset Game Sets The Active Player")
    func testResetGameSetsTheActivePlayer() async throws {
        
        sut.resetGame()
        #expect(sut.activePlayer == .player1)
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test("Reset Game Sets to Nine Nil Objects")
    func testResetGameSetsToNineNilObjects() async throws {
        sut.resetGame()
        #expect(sut.moves.count == 9)
    }

    @Test()
    @available(macOS 15, *)
    func testResetGameSetsGameNotificationToPlayer1() async throws {
        
        sut.resetGame()
        #expect(sut.gameNotification == "it is \(sut.activePlayer.name)'s move")
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test(.tags(.critical))
    func testProcessMovesWillShowFinishAlert() async throws {
        
        for index in 0..<9 {
            sut.processMove(for: index)
        }
        
        #expect(sut.gameNotification == AppString.gameHasFinished)
        
    }
    
    @Test()
    func testProcessMovesWillReturnOccupiedSquare() async throws {
        
        sut.processMove(for: 0)
        sut.processMove(for: 0)
        #expect(sut.moves.compactMap { $0}.count == 1)
        
    }
    
    @Test func testPlayer1WillIncreaseTheScore() async throws {
        
        #expect(sut.player1Score == 0)
        player1Win()
        #expect(sut.player1Score == 1)
        
    }
    
    @Test func testPlayer2WillIncreaseTheScore() async throws {
        
        #expect(sut.player2Score == 0)
        player2Win()
        #expect(sut.player2Score == 1)
        
    }
    
    @Test func testDrawWillShowNotification() {
        produceDraw()
        
        #expect(sut.gameNotification == GameState.draw.name)
    }
    
    @Test mutating func cpuTakeTheMiddleSpot() async throws {
        sut = GameViewModel(gameMode: .vsCPU, onlineRepositrory: OnlineGameRepository())
        
        sut.processMove(for: 0)
        
        // Version 1
//        await confirmation { confirmed in
//            let newSut = self.sut
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                #expect(newSut.moves[4] != nil)
//                confirmed()
//            }
//        }
        
        // Version 2
        try await Task.sleep(nanoseconds: 1_000_000_000)
        #expect(sut.moves[4] != nil)
    }
    
    private func player1Win() {
        sut.processMove(for: 0)
        sut.processMove(for: 2)
        sut.processMove(for: 3)
        sut.processMove(for: 5)
        sut.processMove(for: 6)
    }
    
    private func player2Win() {
        sut.processMove(for: 2)
        sut.processMove(for: 0)
        sut.processMove(for: 5)
        sut.processMove(for: 3)
        sut.processMove(for: 4)
        sut.processMove(for: 6)
    }
    
    private func produceDraw() {
        sut.processMove(for: 0)
        sut.processMove(for: 4)
        sut.processMove(for: 2)
        sut.processMove(for: 1)
        sut.processMove(for: 7)
        sut.processMove(for: 3)
        sut.processMove(for: 5)
        sut.processMove(for: 8)
        sut.processMove(for: 6)
    }
}
