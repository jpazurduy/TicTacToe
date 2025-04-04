//
//  FactorySetup.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 4/4/25.
//

import Foundation
import Factory

@testable import TicTacToe

extension Container {
    static func setupMocks(shouldReturNil: Bool = false) {
        Container.shared.firebaseRepository.register {
            MockFirebaseRepository(shouldReturnNil: shouldReturNil)
        }
    }
}
