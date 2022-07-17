//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by Paul Kirnoz on 15.07.2022.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"),
                                    message: Text("Good job!"),
                                    buttonTitle: Text("Go on"))
    
    static let AIWin    = AlertItem(title: Text("You Lost!"),
                                    message: Text("That's a shame..."),
                                    buttonTitle: Text("Try again"))
    
    
    static let draw     = AlertItem(title: Text("DRAW!"),
                                    message: Text("What a battle it was..."),
                                    buttonTitle: Text("Try Again"))
    
}
