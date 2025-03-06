//
//  FirebaseRepository.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 2/25/25.
//

import Foundation
import Combine

public typealias EncodableIdenfiable = Encodable & Identifiable

protocol FirebaseRepositoryProtocol {
    func getDocuments<T: Codable>(from collection: FSCollectionReference, for playerID: String) async throws -> [T]?
    
    func listen<T: Codable>(from collection: FSCollectionReference, documentID: String) async throws -> AnyPublisher<T?, Error>
    
    func deleteDocument(with id: String, collection: FSCollectionReference)
    
    func saveDocument<T: EncodableIdenfiable>(data: T, to collection: FSCollectionReference) throws
}

class FirebaseRepository: FirebaseRepositoryProtocol {
    
    func getDocuments<T: Codable>(from collection: FSCollectionReference, for playerID: String) async throws -> [T]? {
        let snapshot = try await firebaseReference(collection)
            .whereField(Constant.player2ID, isEqualTo: "")
            .whereField(Constant.player1ID, isNotEqualTo: playerID).getDocuments()
        
        return snapshot.documents.compactMap { queryDocuments -> T? in
            return try? queryDocuments.data(as: T.self)
            
        }
        
    }
    
    func listen<T: Codable>(from collection: FSCollectionReference, documentID: String) async throws -> AnyPublisher<T?, any Error> {
        let subject = PassthroughSubject<T?, Error>()
        let handle = firebaseReference(collection).document(documentID).addSnapshotListener { querySnapshoot, error in
            
            if let error = error {
                subject.send(completion: .failure(error))
                return
            }
            
            guard let document = querySnapshoot else {
                subject.send(completion: .failure(AppError.badSnapshot))
                return
            }
            
            let data = try? document.data(as: T.self)
            
            subject.send(data)
        }
        
        return subject.handleEvents(receiveCancel: {
            handle.remove()
        }).eraseToAnyPublisher()
        
        
    }
    
    func deleteDocument(with id: String, collection: FSCollectionReference) {
        firebaseReference(collection).document(id).delete()
    }
    
    func saveDocument<T: EncodableIdenfiable>(data: T, to collection: FSCollectionReference) throws {
        let id = data.id as? String ?? UUID().uuidString
        
        try firebaseReference(collection).document(id).setData(from: data.self)
    }
    
    
}
