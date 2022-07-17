//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by Paul Kirnoz on 16.07.2022.
//


import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),]
    
    ///creates an array that has 9 items  e.g [nil, nil, Move, nil, Move, nil, Move, nil, nil]
    ///if there's a move in that position – we're gonna have the move object there
    ///this is to make sure there's no move in circle when user taps it
    ///Initially creates an array of 9 nil objects that gets populated with moves later
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        //MARK: Human moves
        
        if isSquareOccupied(in: moves, forIndex: position) { return }
        
        moves[position] = Move(player: .human, boardIndex: position)
        
        if checkWinCondition(for: .human, in: moves) {
            withAnimation(.spring()) {
                alertItem = AlertContext.humanWin
                return
            }
        }
        
        if checkForDraw(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        isGameBoardDisabled = true
        
        
        //MARK: AI moves
        //computer makes a move after 0.5 secs
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            
            //will spin the random Int up to 9 to see if it's not occupied
            let computerPosition = determineComputerMovePosition(in: moves)
            
                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                isGameBoardDisabled = false
            
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertContext.AIWin
                return
            }
            
            if checkForDraw(in: moves) {
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    ///check if the square is occupied by move.
    ///moves array gets passed in as a parameter.
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
        ///if the boardIndex contains the specific index we wanna check  –> return true (because it's unnoccupied circle)
    }
    
    
    //If AI can win -> win
    //If AI can't win -> block
    //If AI can't block -> take the middle circle
    //If Ai can't take the middle circle -> pick random
    
    ///once we've figured out what position we want – here's the position to put the indicator in
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        
        //If AI can win -> win
        let winPatterns: Set<Set<Int>> = [ [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let AIMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let AIPositions = Set(AIMoves.map { $0.boardIndex } )
        
        
        ///goes thorugh each of the WinPatterns to check if there's 2 out of 3
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(AIPositions)
            
            if winPositions.count == 1 {
                //tells if the circle is not occupied
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        //If AI can't win -> block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPositions = Set(humanMoves.map { $0.boardIndex } )
        
        
        ///goes thorugh each of the WinPatterns to check if there's 2 out of 3
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1 {
                //tells if the circle is not occupied
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        //If AI can't block -> take the middle circle
        let centerCircle = 4
        if !isSquareOccupied(in: moves, forIndex: centerCircle) {
            return centerCircle
        }
        
        
        //If Ai can't take the middle circle -> pick random
        var movePosition = Int.random(in: 0..<9) //pick a random position
        
        //checks if the position of "movePosition" is not occupied
        //if is occupied – runs again
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        
        let winPatterns: Set<Set<Int>> = [ [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        ///it removes all the nils from the 9 digit array
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        
        ///goes through all the player moves and returns board indexes, e.g [0, 1, 2]
        let playerPositions = Set(playerMoves.map { $0.boardIndex } )
        
        ///iterates during winPatterns. During iteration wherever
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        
        ///compact map is run to remove all the nils to fit the win/draw/lose condition
        ///after func is called and there are 9 Moves and no win condition –> it's a draw
        return moves.compactMap { $0 }.count == 9 //if all nils are removed and there are 9 moves -> draw
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
