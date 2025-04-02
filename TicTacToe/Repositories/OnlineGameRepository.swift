//
//  OnlineGameRepository.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 2/25/25.
//

import Foundation
import Combine
import Factory

let localPlayerID = UUID().uuidString

final class OnlineGameRepository: ObservableObject {
    
    @Injected(\.firebaseRepository) private var firebaseRepository
    
    @Published var game: Game!
    
    private var cancelables: Set<AnyCancellable> = []
    
    @MainActor
    func joinGame() async {
        if let gamesToJoin: Game = await getGame() {
            self.game = gamesToJoin
            self.game.player2ID = localPlayerID
            self.game.activePlayerID = self.game.player1ID
            
            await updateGame(self.game)
            await listenForChanges(in: self.game.id)
        } else {
            await createGame()
            await listenForChanges(in: self.game.id)
            
        }
    }
    
    @MainActor
    private func createGame() async {
        self.game = Game(id: UUID().uuidString,
                         player1ID: localPlayerID,
                         player2ID: "",
                         player1Score: 0,
                         player2Score: 0,
                         activePlayerID: localPlayerID,
                         winningPlayerID: "",
                         moves: Array(repeating: nil, count: 9))
        
        await self.updateGame(self.game)
    }
    
    @MainActor
    private func listenForChanges(in gameID: String) async {
        do {
            try await firebaseRepository.listen(from: .Game, documentID: gameID)
                .sink { completion in
                    switch completion {
                        case .finished:
                            return
                        case .failure(let error):
                            print("Error", error.localizedDescription)
                    }
                } receiveValue: { [weak self] game in
                    self?.game = game
                }
                .store(in: &cancelables)

        } catch {
            print("Error", error.localizedDescription)
        }
    }
    
    private func getGame() async -> Game? {
        // TODO: - Call getDocument method
        return try? await firebaseRepository.getDocuments(from: .Game, for: localPlayerID)?.first
        
    }
    
    func updateGame(_ game: Game) async {
        // TODO: - Save document
        do {
            try firebaseRepository.saveDocument(data: game, to: .Game)
        } catch {
            print(error)
        }
        
    }
    
    func quitGame() {
        guard game != nil else {
            return
        }
        
        // TODO: - access and  delete firebase game
        firebaseRepository.deleteDocument(with: self.game.id, collection: .Game)
    }
    
}
