//
//  Move.swift
//  super-tic-tac-toe
//
//  Created by Bernardo Santiago Marin on 09/05/24.
//

import Foundation

struct Move {
    let player: Player
    let boardPosition: Int
    
    var symbol: String {
        switch player {
        case .human:
            return "xmark"
        case .computer:
            return "circle"
        }
    }
}
