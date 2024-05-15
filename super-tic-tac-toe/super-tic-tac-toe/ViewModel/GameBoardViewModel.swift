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
    
    /// All posible win combinations
    private let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], // Horizontal win conditions
                                              [0, 3, 6], [1, 4, 7], [2, 5, 8], //   Vertical win conditions
                                              [0, 4, 8], [2, 4, 6]]            //   Diagonal win conditions
    
    /// Returns an available slot to make the computer's best move.
    /// - Returns: Int
    func makeComputerMove() -> Int {

        // If AI can win, then win
        if let next = getNextPositionBeforeWinning(for: .computer) { // Take the winning position
            return next
        }
        
        // If AI can't win, block
        if let next = getNextPositionBeforeWinning(for: .human) { // Get the winning position of human and block it
            return next
        }
        
        // If AI can't block, take middle position
        let middleSquare = 4
        if !isSquareOccupied(forIndex: middleSquare) {
            return middleSquare
        }
        
        // If AI can't take middle position, take one of the edges
        var edges = [0, 2, 6, 8]
        while edges.count > 0 {
            let randomEdge = Int.random(in: 0...edges.count - 1)
            if !isSquareOccupied(forIndex: edges[randomEdge]) {
                return edges[randomEdge]
            }
            edges.remove(at: randomEdge)
        }
        
        // If AI can't take an edge position, choose random slot
        var movePosition: Int
        
        repeat {
            movePosition = Int.random(in: 0...8)
        } while isSquareOccupied(forIndex: movePosition)
        
        return movePosition
    }
    
    /// Checks if the given player has already won.
    /// - Returns: Bool
    func checkIfWinner(player: Player) -> Bool {
        let playerPositions = getMoves(for: player)
        
        // If we find at least one case where a win pattern is a sub-set of the player positions, then it wins.
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        // Otherwise, the player has not won
        return false
    }
    
    private func getMoves(for player: Player) -> Set<Int> {
        let moves = board.compactMap{ $0 }.filter{ $0.player == player }   // Gets all non-nil values of `board` and filters the player we're looking at
        let positions = Set(moves.map{ $0.boardPosition }) // Create the set of only positions where the player has marked
        return positions
    }
    
    
    /// If the provided player is one step away from winning, returns the index of the winning position.
    /// - Parameter player: Player
    /// - Returns: Int?
    private func getNextPositionBeforeWinning(for player: Player) -> Int? {
        let moves = getMoves(for: player)
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(moves) // Compare the win patterns to the positions it has marked
            if winPositions.count == 1 { // If it's missing only one position to win, take it
                let isAvailable = !isSquareOccupied(forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        return nil
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
    
    /// If available, puts the human's symbol at the index tapped
    /// and makes computer move while checking for winners on both ends.
    func handlePlayerTap(at index: Int) {
        // Check if tapped index is occupied. If it isn't, then
        // place the player's mark and calculate the computer's move.
        if isSquareOccupied(forIndex: index) { return }
        self.board[index] = Move(player: .human, boardPosition: index)
        if self.checkIfWinner(player: .human) {
            self.alert = GameAlerts.humanWinerAlert
            return
        }
        
        if self.checkForDraw() {
            self.alert = GameAlerts.drawAlert
            return
        }
        
        self.isGameBoardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let computerMove = self.makeComputerMove() // Guaranteed free slot
            self.board[computerMove] = Move(player: .computer, boardPosition: computerMove)
            if self.checkIfWinner(player: .computer) {
                self.alert = GameAlerts.computerWinerAlert
                return
            }
            
            if self.checkForDraw() {
                self.alert = GameAlerts.drawAlert
                return
            }
            self.isGameBoardDisabled = false
        }
    }
}
