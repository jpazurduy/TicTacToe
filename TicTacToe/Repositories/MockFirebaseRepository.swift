//
//  MockFirebaseRepository.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 4/3/25.
//

import Foundation
import Combine

final class MockFirebaseRepository: FirebaseRepositoryProtocol {
    
    let dumpGame = Game(id: "MOCK",
                        player1ID: "Play1",
                        player2ID: "Play2",
                        player1Score: 2,
                        player2Score: 3,
                        activePlayerID: "Play1",
                        winningPlayerID: "",
                        moves: Array(repeating: nil, count: 9))
    
    var returnNil = false
    
    init(shouldReturnNil: Bool = false) {
        self.returnNil = shouldReturnNil
    }
    
    func getDocuments<T>(from collection: TicTacToe.FSCollectionReference, for playerID: String) async throws -> [T]? where T : Decodable, T : Encodable {
        print("sending mock")
        return returnNil ? nil : [dumpGame] as? [T]
    }
    
    func listen<T>(from collection: TicTacToe.FSCollectionReference, documentID: String) async throws -> AnyPublisher<T?, any Error> where T : Decodable, T : Encodable {
        let subject = PassthroughSubject<T?, Error>()
        
        subject.send(dumpGame as? T)
        return subject.eraseToAnyPublisher()
    }
    
    func deleteDocument(with id: String, collection: TicTacToe.FSCollectionReference) {
        
    }
    
    func saveDocument<T>(data: T, to collection: TicTacToe.FSCollectionReference) throws where T : Encodable, T : Identifiable {
        
    }
    
    
    
}
