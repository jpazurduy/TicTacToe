//
//  GameView.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 1/23/25.
//

import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) var dismiss
    
    
    @ObservedObject var viewModel: GameViewModel
    
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
    }
    
    @ViewBuilder
    private func scoreView() -> some View {
        HStack {
            Text("Player 1: 0")
            Spacer()
            Text("Player 2: 0")
        }
        .foregroundStyle(.white)
        .font(.title2)
        .fontWeight(.semibold)
    }
    
    @ViewBuilder
    private func gameStatus() -> some View {
        Text(viewModel.gameNotification)
            .font(.title2)
            .foregroundStyle(.white)
            .fontWeight(.bold)
    }
    
    @ViewBuilder
    private func gameBoard(geometryProxy: GeometryProxy) -> some View {
        VStack {
            LazyVGrid(columns: viewModel.colums, spacing: 10) {
                ForEach(0..<9) { index in
                    ZStack {
                        BoardCircleView(geometryReader: geometryProxy)
                        BoardIndicatorView(imageName: viewModel.moves[index]?.indicator ?? "")
                    }
                    .onTapGesture {
                        viewModel.processMove(for: index)
                    }
                }
            }
        }
        .padding(.bottom, 10)
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
            .background(.indigo)
        }
    }

    var body: some View {
        main()
    }
}

#Preview {
    GameView(viewModel: GameViewModel(gameMode: .vsCPU))
}
