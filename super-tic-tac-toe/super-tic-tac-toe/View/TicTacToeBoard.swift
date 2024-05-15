//
//  TicTacToeBoard.swift
//  super-tic-tac-toe
//
//  Created by Bernardo Santiago Marin on 09/05/24.
//

import SwiftUI

struct TicTacToeBoard: View {
    
    let columns: [GridItem] = .init(repeating: .init(.flexible()), count: 3)
    @StateObject var GameBoard = GameBoardViewModel()
    @State private var boardColor: Color = .green
    
    var body: some View {
        VStack {
            VStack {
                GameAlert(alertComponent: GameBoard.alert, resetGame: GameBoard.resetGame)
                    .padding(.horizontal)
            }
            
            // MARK: Tic Tac Toe Grid
            LazyVGrid(columns: columns) {
                ForEach(0..<9) { i in
                    ZStack {
                        Circle()
                            .foregroundStyle(boardColor)
//                                            .overlay(Color.white.mask(Circle()).opacity(0.3))
                        if let move = GameBoard.board[i] {
                            Image(systemName: move.symbol)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.white)
                        }
                    }
                    .onTapGesture {
                        GameBoard.handlePlayerTap(at: i)
                    }
                }
            }
            .padding()
            .disabled(GameBoard.isGameBoardDisabled)
            .blur(radius: GameBoard.alert != GameAlerts.defaultAlert ? 5 : 0)
            
            ColorPicker(selectedColor: self.$boardColor)
        }
        .animation(.easeOut, value: GameBoard.alert)
        .animation(.easeOut, value: self.boardColor)
    }
}

#Preview {
    TicTacToeBoard()
}
