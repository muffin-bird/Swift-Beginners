//
//  ContentView.swift
//  MyMusic
//
//  Created by muffin man on 2021/07/01.
//

import SwiftUI

struct ContentView: View {
    let soundPlayer = SoundPlayer()
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .aspectRatio(contentMode: .fill)
            
            HStack {
                
                Button(action: {
                    soundPlayer.cymbalPlay()
                }) {
                    Image("cymbal")
                        .renderingMode(.original)
                }
                
                Button(action: {
                    soundPlayer.guitarPlay()
                }) {
                    Image("guitar")
                        .renderingMode(.original)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
