//
//  AlertItem.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 2/7/25.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let buttonTitle: Text
    
    init(title: String, message: String, buttonTitle: String = AppString.rematch) {
        self.title = Text(title)
        self.message = Text(message)
        self.buttonTitle = Text(buttonTitle)
    }
}
