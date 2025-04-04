//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 1/24/25.
//

import SwiftUI
import Combine

final class GameViewModel: ObservableObject {
    var onlineRepositrory: OnlineGameRepository
    
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
    @Published private(set) var isGameBoardDisable = false
    
    @Published private(set) var activePlayer: Player = .player1
    
    @Published private(set) var alertItem: AlertItem?
    
    @Published var gameMode: GameMode
    @Published private var players: [Player] = []
    
    @Published var showAlert: Bool = false
    @Published private var onlineGame: Game?
    @Published var showLoadign = false
    
    private var cancelables: Set<AnyCancellable> = []
    
    init(gameMode: GameMode, onlineRepositrory: OnlineGameRepository) {
        self.gameMode = gameMode
        self.onlineRepositrory = onlineRepositrory
        
        switch gameMode {
            case .vsCPU:
                self.players = [.player1, .cpu]
            case .vsHuman:
                self.players = [.player1, .player2]
            case .vsOnline:
                self.players = [.player1, .player2]
                startOnlineGame()
        }
        
        self.gameNotification = "it is \(activePlayer.name)'s move"
        observeData()
    }
    
    private func observeData() {
        $players
            .map{ $0.first?.name ?? ""}
            .assign(to: &$player1Name)
        
        $players
            .map{ $0.last?.name ?? ""}
            .assign(to: &$player2Name)
        
        onlineRepositrory.$game
            .map { $0 }
            .assign(to: &$onlineGame)
        
        $onlineGame
            .map{ $0?.moves ?? Array(repeating: nil, count: 9)}
            .assign(to: &$moves)
        
        $onlineGame
            .map{ $0?.player1Score ?? 0}
            .assign(to: &$player1Score)
        
        $onlineGame
            .map{ $0?.player2Score ?? 0}
            .assign(to: &$player2Score)
        
        $onlineGame
            .drop(while: { $0 == nil })
            .map{ $0?.player2ID == ""}
            .assign(to: &$showLoadign)
        
        $onlineGame
            .drop(while: { $0 == nil })
            .sink { updateValue in
                self.syncOnlineWithLocal(onlineGame: updateValue)
                
            }
            .store(in: &cancelables)
    }
    
    private func syncOnlineWithLocal(onlineGame: Game?) {
        guard let game = onlineGame else {
            showAlert(for: .quit)
            return
        }
        
        if game.winningPlayerID == "0" {
            self.showAlert(for: .draw)
        } else if game.winningPlayerID != "" {
            self.showAlert(for: .finished)
        }
        
        // set disalble state
        isGameBoardDisable = game.player2ID == "" ? true : localPlayerID != game.activePlayerID
        
        
        // set active player
        setActivePlayerAndNotification(from: game)
        
        // set notification
        if game.player2ID == "" {
            gameNotification = AppString.waitingForPlayer
        }
        
    }
    
    private func setActivePlayerAndNotification(from game: Game) {
        if localPlayerID == game.player1ID {
            // we are player 1
            
            if localPlayerID == game.activePlayerID {
                self.activePlayer = .player1
                
                // notification
                self.gameNotification = AppString.yourMove
            } else {
                // notification
                self.gameNotification = "It is \(activePlayer.name)'s move"
            }
        } else {
            // we are player 2
            if localPlayerID == game.activePlayerID {
                self.activePlayer = .player2
                self.gameNotification = AppString.yourMove
            } else {
                self.gameNotification = "It is \(activePlayer.name)'s move"
            }
        }
    }
    
    private func startOnlineGame() {
//        gameNotification = AppString.waitingForPlayer
//        // Show loading spin wheel
        Task {
            await onlineRepositrory.joinGame()
        }
    }
    
    func processMove(for position: Int) {
        print(activePlayer.name)
        // it is the positionn occupaied
        if isSquareOccupied(in: moves, for: position) { return }
        
        moves[position] = GameMove(player: activePlayer, boardIndex: position)
        
        
        // TODO: - Check for win
        if checkForWin(in: moves) {
            // show alert to user
            showAlert(for: .finished)
            
            increaseScore()
            // increase the score of winner
            // update online game
            updateOnlineGame(gameProcess: .win)
            
            return
        }
        // TODO: - Check for draw
        
        if checkForDraw(in: moves) {
            // show alert to user
            showAlert(for: .draw)
            
            // update online game
            updateOnlineGame(gameProcess: .draw)
            return
        }
        // TODO: - Continue the game
        
        activePlayer = players.first(where: {$0 != activePlayer})!
        if gameMode == .vsCPU && activePlayer == .cpu {
            isGameBoardDisable = true
            computerMove()
        }
        
        // update online game
        updateOnlineGame(gameProcess: .move)
        self.gameNotification = "it is \(activePlayer.name)'s move"
    }
    
    private func updateOnlineGame(gameProcess: GameProcess) {
        guard var tempGame = onlineGame else { return }
        
        isGameBoardDisable = localPlayerID != tempGame.activePlayerID
        
        tempGame.activePlayerID = tempGame.activePlayerID == tempGame.player1ID ? tempGame.player2ID : tempGame.player1ID
        
        tempGame.player1Score = player1Score
        tempGame.player2Score = player2Score
        
        switch gameProcess {
            case .win:
                tempGame.winningPlayerID = localPlayerID
            case .draw:
                tempGame.winningPlayerID = "0"
                tempGame.activePlayerID = tempGame.player1ID
            case .reset:
                tempGame.winningPlayerID = ""
                tempGame.activePlayerID = tempGame.player1ID
            case .move:
                break
        }
        
        tempGame.moves = moves
        
        Task {
            await onlineRepositrory.updateGame(tempGame)
        }
    }
    
    private func computerMove() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [self] in
            processMove(for: getAIMovePosition(in: moves))
            isGameBoardDisable = false
        }
    }
    
    private func getAIMovePosition(in moves: [GameMove?]) -> Int {
        let centerSquare = 4
        
        // if we can win
        let computerMoves = moves.compactMap { $0 }.filter{ $0.player == .cpu }
        let computerPositions = Set(computerMoves.map {$0.boardIndex} )
        
        if let position = getTheWinningSpot(for: computerPositions) {
            return position
        }
                                           
        // block the player
        let humanMoves = moves.compactMap { $0 }.filter{ $0.player == .player1 }
        let humanPositions = Set(humanMoves.map {$0.boardIndex} )
        
        if let position = getTheWinningSpot(for: humanPositions) {
            return position
        }
                                           
        // take the middle
        if !isSquareOccupied(in: moves, for: centerSquare) {
            return centerSquare
        }
        
        // take a random spot
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, for: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    private func getTheWinningSpot(for positions: Set<Int>) -> Int? {
        for pattern in winPatterns {
            let winPosition = pattern.subtracting(positions)
            
            if winPosition.count == 1 &&  !isSquareOccupied(in: moves, for: winPosition.first!) {
                return winPosition.first!
            }
            
        }
        return nil
    }
    
    private func isSquareOccupied(in moves: [GameMove?], for index: Int) -> Bool {
        let result = moves.contains(where: { $0?.boardIndex == index })
        return result
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
    
    private func increaseScore() {
        if activePlayer == .player1 {
            player1Score+=1
        } else {
            player2Score+=1
        }
    }
    private func showAlert(for state: GameState) {
        gameNotification = state.name
        
        switch state {
            case .finished, .draw, .waitingForPlayer:
                let title = state == .finished ? "\(activePlayer.name) has won" : state.name
                alertItem = AlertItem(title: title, message: AppString.tryRematch)
            case .quit:
                let title = state.name
                alertItem = AlertItem(title: title, message: "", buttonTitle: "OK")
                isGameBoardDisable = true
        }
        showAlert = true
    }
    
    func resetGame() {
        activePlayer = .player1
        moves = Array(repeating: nil, count: 9)
        
        
        if gameMode == .vsOnline {
            updateOnlineGame(gameProcess: .reset)
        } else {
            gameNotification = "it is \(activePlayer.name)'s move"
        }
    }
    
    func quitGame() {
        onlineRepositrory.quitGame()
    }
}
