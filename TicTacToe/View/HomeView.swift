//
//  HomeView.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 1/23/25.
//

import SwiftUI

struct HomeView: View {
    
    @State var gameMode: GameMode?
    
    @ViewBuilder
    private func titleView() -> some View {
        VStack(spacing: 20) {
            Image(systemName: "number")
                .renderingMode(.original)
                .resizable()
                .frame(width: 180, height: 180, alignment: .center)
            
            Text("TicTacToe")
                .font(.largeTitle)
                .fontWeight(.semibold)
        }
        .foregroundStyle(.indigo)
        .padding(.top, 50)
    }
    
    @ViewBuilder
    private func buttonView() -> some View {
        VStack(spacing: 15) {
            ForEach(GameMode.allCases, id: \.self) { mode in
                Button {
                    self.gameMode = mode
                } label: {
                    Text(mode.name)
                }
                .buttonStyle(AppButtonStyle.appButton(color: mode.color))
            }

        }
        .padding(.horizontal, 16)
        .padding(.bottom, 50)
    }
    
    @ViewBuilder
    private func main() -> some View {
        VStack {
            titleView()
            Spacer()
            buttonView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.91, green: 0.89, blue: 0.90    ))
    }
    
    var body: some View {
        main()
            .fullScreenCover(item: $gameMode) { gameMode in
                GameView(viewModel: GameViewModel(gameMode: gameMode, onlineRepositrory: OnlineGameRepository()))
            }
    }
}

#Preview {
    HomeView()
}
