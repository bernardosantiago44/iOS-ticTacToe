//
//  AlertComponent.swift
//  super-tic-tac-toe
//
//  Created by Bernardo Santiago Marin on 10/05/24.
//

import Foundation

struct AlertComponent: Identifiable, Equatable {
    let id = UUID()
    
    var title: String
    var message: String
    var buttonMessage: String?
}

struct GameAlerts {
    static let humanWinerAlert = AlertComponent(title: "Human wins",
                                                message: "Congratulations!",
                                                buttonMessage: "Play again")
    
    static let computerWinerAlert = AlertComponent(title: "Computer wins",
                                                   message: "Your AI is pretty good",
                                                   buttonMessage: "Try again")
    
    static let drawAlert = AlertComponent(title: "Draw",
                                          message: "Tough match, huh?",
                                          buttonMessage: "Play again")
    
    static let defaultAlert = AlertComponent(title: "Super Tic-tac-toe", message: "Let's play a game of tic-tac-toe", buttonMessage: nil)
    
    private init() {}
}
