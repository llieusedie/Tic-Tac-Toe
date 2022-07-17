//
//  GameView.swift
//  Tic-Tac-Toe
//
//  Created by Paul Kirnoz on 14.07.2022.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        
        
        
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("Tic-Tac-Toe")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                .padding(.leading)
                Spacer()
                
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            GameBoardView(proxy: geometry)
                            PlayerIndicator(systemImageName: viewModel.moves[i]?.indicator ?? "")
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                            
                        }
                    }
                    .border(.black, width: 5).shadow(radius: 3)
                }
                Spacer()
                HStack(spacing: 20) {
                    Button {
                        viewModel.resetGame()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .frame(width: 50, height: 55)
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(.white)
                                    .border(.black, width: 5)
                                    .shadow(radius: 4)
                            )
                    }
                    
//                    Button {
//                        //
//                    } label: {
//
//                        Image(systemName: "person.fill")
//                            .resizable()
//                            .frame(width: 55, height: 55)
//                            .font(.headline)
//                            .foregroundColor(.black)
//                            .padding()
//                            .background(
//                                RoundedRectangle(cornerRadius: 15)
//                                    .foregroundColor(.white)
//                                    .border(.black, width: 5)
//                                    .shadow(radius: 4)
//                            )
//                    }
                }
            }
            .disabled(viewModel.isGameBoardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: {
                    viewModel.resetGame() }))
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct GameBoardView: View {
    
    var proxy: GeometryProxy
    
    var body: some View {
        Rectangle()
            .foregroundColor(.black).opacity(0.8)
            .frame(width: proxy.size.width/3 - 15,
                   height: proxy.size.height/3 - 150)
            .shadow(color: .white, radius: 3, x: 5, y: 5)
    }
}

struct PlayerIndicator: View {
    
    var systemImageName: String
    
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
            .font(.headline)
            .shadow(radius: 15)
        
    }
}
