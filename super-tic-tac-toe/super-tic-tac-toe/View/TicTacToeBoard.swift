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
                        // Check if tapped index is occupied. If it isn't, then
                        // place the player's mark and calculate the computer's move.
                        if GameBoard.isSquareOccupied(forIndex: i) { return }
                        GameBoard.board[i] = Move(player: .human, boardPosition: i)
                        if GameBoard.checkIfWinner(player: .human) {
                            GameBoard.alert = GameAlerts.humanWinerAlert
                            return
                        }
                        
                        if GameBoard.checkForDraw() {
                            GameBoard.alert = GameAlerts.drawAlert
                            return
                        }
                        
                        GameBoard.isGameBoardDisabled = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            let computerMove = GameBoard.makeComputerMove() // Guaranteed free slot
                            GameBoard.board[computerMove] = Move(player: .computer, boardPosition: computerMove)
                            if GameBoard.checkIfWinner(player: .computer) {
                                GameBoard.alert = GameAlerts.computerWinerAlert
                                return
                            }
                            
                            if GameBoard.checkForDraw() {
                                GameBoard.alert = GameAlerts.drawAlert
                                return
                            }
                            GameBoard.isGameBoardDisabled = false
                        }
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

struct GameAlert: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    let alertComponent: AlertComponent
    var resetGame: () -> Void
    
    var body: some View {
        ZStack {
            if dynamicTypeSize < .xxxLarge {
                HStack {
                    textAndMessage
                    playAgainButton
                }
                .padding()
            } else {
                VStack {
                    textAndMessage
                    playAgainButton
                }
                .padding()
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 15).foregroundStyle(.thinMaterial)
        }
    }
    
    var playAgainButton: some View {
        Group {
            if let buttonMessage = alertComponent.buttonMessage {
                Button(buttonMessage) {
                    resetGame()
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .foregroundStyle(.white)
            }
        }
    }
    
    var textAndMessage: some View {
        VStack(alignment: .leading) {
            Text(alertComponent.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .bold()
            Text(alertComponent.message)
                .font(.body)
        }
        .foregroundStyle(.primary)
    }
}

#Preview {
    TicTacToeBoard()
}
