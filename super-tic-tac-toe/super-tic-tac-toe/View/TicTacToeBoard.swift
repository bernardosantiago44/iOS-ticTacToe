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
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<9) { i in
                ZStack {
                    Circle()
                        .foregroundStyle(.green)
                    //                    .overlay(Color.white.mask(Circle()).opacity(0.3))
                    if let move = GameBoard.board[i] {
                        Image(systemName: move.symbol)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.white)
                    }
                }
                .onTapGesture {
                    // Check if tapped index is occupied. If it isn't, then
                    // place the player's mark and calculate the computer's move.
                    if GameBoard.isSquareOccupied(forIndex: i) { return }
                    GameBoard.board[i] = Move(player: .human, boardPosition: i)
                    GameBoard.isGameBoardDisabled = true
                    if GameBoard.checkIfWinner(player: .human) {
                        print("Human wins")
                        return
                    }
                    
                    if GameBoard.checkForDraw() {
                        print("draw")
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let computerMove = GameBoard.makeComputerMove()
                        GameBoard.board[computerMove] = Move(player: .computer, boardPosition: computerMove)
                        GameBoard.isGameBoardDisabled = false
                        if GameBoard.checkIfWinner(player: .computer) {
                            print("Computer wins")
                            return
                        }
                        
                        if GameBoard.checkForDraw() {
                            print("draw")
                        }
                    }
                }
            }
        }
        .padding()
        .disabled(GameBoard.isGameBoardDisabled)
    }
}

#Preview {
    TicTacToeBoard()
}
