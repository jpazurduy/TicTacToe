//
//  TestSwiftUI.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 1/28/25.
//

import SwiftUI

struct TestSwiftUI: View {
    @State var isAnimating = false
    @State private var showDetails = false
    @State private var isVisible = false
    
    @State var color: Color = .green
    
    var body: some View {
        VStack {
            
            if isVisible {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.blue)
                    .frame(width: 50, height: 50, alignment: .center)
                    .transition(.opacity)
                
            }
            
//            Text("Hello, World!")
//                //.offset(x: isAnimating ? 100 : 0)
//                .transition(.slide)
//                .foregroundStyle(color)
//                .scaleEffect(isAnimating ? 2 : 0)
//                .onChange(of: isAnimating) { oldValue, newValue in
//                    print(oldValue)
//                    print(newValue)
//                    withAnimation(.easeIn(duration: 3)) {
//                        self.color = .red
//                    }
//                    
//                    
//                }
            
            Button {
                withAnimation(.spring(duration: 0.5).repeatForever(autoreverses: true)) {
                    isAnimating.toggle()
                    showDetails.toggle()
                    isVisible.toggle()
                }
                
            } label: {
                Text("Press me")
            }
            
            if showDetails {
                // Moves in from the bottom
                Text("Details go here.")
                    .transition(.move(edge: .bottom))

                // Moves in from leading out, out to trailing edge.
                Text("Details go here.")
                    .transition(.slide)

                // Starts small and grows to full size.
                Text("Details go here.")
                    .transition(.scale)
            }

        }
        
    }
}

#Preview {
    TestSwiftUI()
}
