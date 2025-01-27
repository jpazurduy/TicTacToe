//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 1/24/25.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let colums: [GridItem] = [ GridItem(.flexible()),
                                  GridItem(.flexible()),
                                  GridItem(.flexible())
                                ]
}
