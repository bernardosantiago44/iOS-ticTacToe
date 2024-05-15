//
//  WelcomeScreen.swift
//  super-tic-tac-toe
//
//  Created by Bernardo Santiago Marin on 12/05/24.
//

import SwiftUI

struct MainScreen: View {
    
    @State private var difficulty: Difficulty = .easy
    
    var body: some View {
        VStack {
            Text("Super Tic-Tac-Toe")
                .fontDesign(.serif)
                .font(.title)
                .bold()
            Picker("Select difficulty", selection: self.$difficulty) {
                ForEach(Difficulty.allCases, id: \.rawValue) { diff in
                    Text(diff.stringRepresentation)
                        .tag(diff)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            NavigationLink {
                TicTacToeBoard()
                    .navigationBarBackButtonHidden(true)
            } label: {
                Text("Start game")
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

#Preview {
    NavigationStack {
        MainScreen()
    }
}
