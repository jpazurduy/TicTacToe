//
//  Untitled.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 2/25/25.
//

import FirebaseCore
import FirebaseFirestore

enum FSCollectionReference: String {
    case Game
}

func firebaseReference(_ reference: FSCollectionReference) -> CollectionReference {
    Firestore.firestore().collection(reference.rawValue)
}
