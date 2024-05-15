//
//  Difficulty.swift
//  super-tic-tac-toe
//
//  Created by Bernardo Santiago Marin on 12/05/24.
//

import Foundation


/// A comparable type to select the game's difficulty.
enum Difficulty: Int, Comparable, Hashable, CaseIterable {
    public static func < (lhs: Difficulty, rhs: Difficulty) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    case easy = 0
    case medium = 1
    case difficult = 2
    
    var stringRepresentation: String {
        switch self {
        case .easy:
            return "Baby mode"
        case .medium:
            return "Hard"
        case .difficult:
            return "Unbeatable"
        }
    }
}
