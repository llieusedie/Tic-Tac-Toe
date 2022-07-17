//
//  GameModel.swift
//  Tic-Tac-Toe
//
//  Created by Paul Kirnoz on 16.07.2022.
//

import Foundation
import SwiftUI

enum Player {
    case human, computer
}

///checks: what player made the move, where on the board was it
struct Move {
    let player: Player
    let boardIndex: Int
    
    ///SFsymbol
    var indicator: String {
        ///if the player is human...
        return player == .human ? "xmark" : "circle"
    }
}
