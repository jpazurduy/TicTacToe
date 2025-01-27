//
//  GameMOde.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 1/23/25.
//

import SwiftUI

enum GameMode: CaseIterable, Identifiable {
    var id: Self { return self }
    case vsHuman, vsCPU, vsOnline
    
    var name: String {
        switch self {
            case .vsHuman:
                return AppString.vsHuman
            case .vsCPU:
                return AppString.vsCPU
            case .vsOnline:
                return AppString.vsOnline
            default:
                return AppString.vsCPU
        }
    }
    
    var color: Color {
        switch self {
            case .vsHuman:
                return Color.indigo
            case .vsCPU:
                return Color.red
            case .vsOnline:
                return Color.green
            default:
                return Color.red
        }
    }
}
