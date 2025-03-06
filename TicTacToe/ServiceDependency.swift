//
//  Untitled.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 2/26/25.
//

import Foundation
import Factory

extension Container {
    var firebaseRepository: Factory<FirebaseRepositoryProtocol> {
        self { FirebaseRepository() }
            .shared
    }
}
