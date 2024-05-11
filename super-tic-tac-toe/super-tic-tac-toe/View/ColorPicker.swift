//
//  ColorPicker.swift
//  super-tic-tac-toe
//
//  Created by Bernardo Santiago Marin on 10/05/24.
//

import SwiftUI

struct ColorPicker: View {
    let columns: [GridItem] = [.init(.adaptive(minimum: 45))]
    let colors: [Color] = [.red, .orange, .yellow, .green, .cyan, .blue, .purple, .pink, .brown]
    @Binding var selectedColor: Color
    
    var body: some View {
        LazyVGrid(columns: self.columns) {
            ForEach(colors, id: \.self) { color in
                Circle()
                    .foregroundStyle(color)
                    .frame(width: 50, height: 50)
                    .overlay {
                        if selectedColor == color {
                            Circle()
                                .stroke(style: .init(lineWidth: 4))
                                .foregroundStyle(.primary)
                                .colorInvert()
                                .frame(width: 40, height: 40)
                        }
                    }
                    .onTapGesture {
                        self.selectedColor = color
                    }
            }
        }
        .padding()
    }
}

#Preview {
    ColorPicker(selectedColor: .constant(.green))
}
