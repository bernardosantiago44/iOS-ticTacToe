//
//  GameBoardViewModel.swift
//  super-tic-tac-toe
//
//  Created by Bernardo Santiago Marin on 09/05/24.
//

import Foundation

final class GameBoardViewModel: ObservableObject {
    
    /// Holds the current game's movements, using nil to represent an open slot
    /// and an instance of type Move to represent a human mark or a computer mark.
    ///
    @Published var board: [Move?] = Array(repeating: nil, count: 9)
    
    @Published var isGameBoardDisabled = false
    
    /// Used to hold, show and dismiss winning or draw alerts
    @Published var alert: AlertComponent = GameAlerts.defaultAlert
    
    
    /// Returns whether a given index is occupied by a move in `board`
    /// - Parameter index: A number from 0 to 9 representing a board position
    /// - Returns: Bool
    func isSquareOccupied(forIndex index: Int) -> Bool {
        return board.contains(where: { $0?.boardPosition == index })
    }
    
    /// Returns a random available slot to make the computer's move.
    /// - Returns: Int
    func makeComputerMove() -> Int {
        var movePosition: Int
        
        repeat {
            movePosition = Int.random(in: 0...8)
        } while isSquareOccupied(forIndex: movePosition)
        
        return movePosition
    }
    
    /// Checks if the given player has already won.
    /// - Returns: Bool
    func checkIfWinner(player: Player) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], // Horizontal win conditions
                                          [0, 3, 6], [1, 4, 7], [2, 5, 8], //   Vertical win conditions
                                          [0, 4, 8], [2, 4, 6]]            //   Diagonal win conditions
        
        let playerMoves = board.compactMap{ $0 }.filter{ $0.player == player } // Gets all non-nil values of `board` and filters the player we're looking at
        let playerPositions = Set(playerMoves.map{ $0.boardPosition })
        
        // If we find at least one case where a win pattern is a sub-set of the player positions, then it wins.
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        // Otherwise, the player has not won
        return false
    }
    
    /// Checks if the game has resulted in draw.
    func checkForDraw() -> Bool {
        return board.compactMap{ $0 }.count == 9
    }
    
    func resetGame() {
        self.board = Array(repeating: nil, count: 9)
        self.isGameBoardDisabled = false
        self.alert = GameAlerts.defaultAlert
    }
}
