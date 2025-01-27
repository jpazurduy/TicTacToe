//
//  GameView.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 1/23/25.
//

import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) var dismiss
    var mode: GameMode
    
    var viewModel = GameViewModel()
    
    @ViewBuilder
    private func closeButton() -> some View {
        HStack {
            Spacer()
            Button {
                dismiss()
            } label: {
                Text(AppString.exit)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.red)
            }
            .frame(width: 80, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            )
            .padding(.bottom, 20)

        }
        .background(.green)
    }
    
    @ViewBuilder
    private func scoreView() -> some View {
        HStack {
            Text("Player 1")
            Spacer()
            Text("Player 2")
        }
        .background(.gray)
        .foregroundStyle(.white)
        .font(.title2)
        .fontWeight(.semibold)
    }
    
    @ViewBuilder
    private func gameStatus() -> some View {
        Text("Once move")
            .font(.title2)
            .foregroundStyle(.pink)
    }
    
    @ViewBuilder
    private func gameBoard(geometryProxy: GeometryProxy) -> some View {
        VStack {
            LazyVGrid(columns: viewModel.colums, spacing: 10) {
                ForEach(0..<9) { index in
                    Text("hello \(index)")
                }
            }
        }
        .padding(.bottom, 10)
        .background(.white)
    }
    
    @ViewBuilder
    private func main() -> some View {
        GeometryReader { geometry in
            VStack {
                closeButton()
                scoreView()
                
                Spacer()
                
                gameStatus()
                
                Spacer()
                
                gameBoard(geometryProxy: geometry)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 16)
            .background(.yellow)
        }
    }

    var body: some View {
        main()
    }
}

#Preview {
    GameView(mode: GameMode.vsCPU)
}
