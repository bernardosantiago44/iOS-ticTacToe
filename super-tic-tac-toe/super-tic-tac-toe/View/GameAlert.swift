//
//  GameAlert.swift
//  super-tic-tac-toe
//
//  Created by Bernardo Santiago Marin on 15/05/24.
//

import SwiftUI

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
    Group {
        GameAlert(alertComponent: GameAlerts.defaultAlert, resetGame: {})
        GameAlert(alertComponent: GameAlerts.superTTTGame, resetGame: {})
        GameAlert(alertComponent: GameAlerts.computerWinerAlert, resetGame: {})
        GameAlert(alertComponent: GameAlerts.drawAlert, resetGame: {})
        GameAlert(alertComponent: GameAlerts.humanWinerAlert, resetGame: {})
    }
    .padding(.horizontal)
}
