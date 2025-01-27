//
//  AppButtonStyle.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 1/23/25.
//

import SwiftUI

struct AppButtonStyle: ButtonStyle {
    //typealias Body = <#type#>
    
    let color: Color
    
    init(color: Color) {
        self.color = color
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .font(.title2)
            .fontWeight(.semibold)
            .padding()
            .background(color)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .shadow(radius: 8)
        
    }
}

extension AppButtonStyle {
    static func appButton(color: Color) -> AppButtonStyle {
        AppButtonStyle(color: color)
    }
}
