//
//  BoardCircleView.swift
//  TicTacToe
//
//  Created by Jorge Azurduy on 1/24/25.
//

import SwiftUI

struct BoardCircleView: View {
    
    var geometryReader: GeometryProxy
    
    @State var sizeDivider: CGFloat = 3
    @State var padding: CGFloat = 15
    
    var body: some View {
        Circle()
            .fill(.red)
            .frame(width: geometryReader.size.width / sizeDivider - padding, height: geometryReader.size.height / sizeDivider - padding)
    }
}

#Preview {
    GeometryReader { geometry in
        BoardCircleView(geometryReader: geometry)
    }
}
