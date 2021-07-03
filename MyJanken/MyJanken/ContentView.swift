//
//  ContentView.swift
//  MyJanken
//
//  Created by muffin man on 2021/06/30.
//

import SwiftUI

struct ContentView: View {
    
    @State var answerNumber = 0
    
    var body: some View {
        // 垂直にレイアウト
        VStack {
            // スペース
            Spacer()
            
            // 数字が0の場合
            if answerNumber == 0 {
                Text("これからじゃんけんをします!")
                    
                    //  余白設定
                    .padding(.bottom)
            } else if answerNumber == 1 {
                // 数字が1の場合はグー
                Image("gu")
                    // リサイズを指定
                    .resizable()
                    // アスペクト比を指定
                    .aspectRatio(contentMode: .fit)
                
                // スペース
                Spacer()
                
                // ジャンケンの種類を指定
                Text("グー")
                    //  余白設定
                    .padding(.bottom)
                
            } else if answerNumber == 2 {
                // 数字が2の場合はチョキ
                Image("choki")
                    // リサイズを指定
                    .resizable()
                    // アスペクト比を指定
                    .aspectRatio(contentMode: .fit)
                
                // スペース
                Spacer()
                
                // ジャンケンの種類を指定
                Text("チョキ")
                    //  余白設定
                    .padding(.bottom)
                
            } else {
                // 数字が3の場合はパー
                Image("pa")
                    // リサイズを指定
                    .resizable()
                    // アスペクト比を指定
                    .aspectRatio(contentMode: .fit)
                
                // スペース
                Spacer()
                // ジャンケンの種類を指定
                Text("パー")
                    //  余白設定
                    .padding(.bottom)
                
            }
            
            // {じゃんけんをする！}ボタン
            Button(action: {
                // 新しいじゃんけんの結果を一時的に格納する変数
                var newAnswerNumber = 0
                
                // ランダムに結果を出すが前回の結果と異なる場合のみ採用
                // repeatは繰り返し
                repeat {
                    // 1,2,3の変数をランダムに算出
                    newAnswerNumber = Int.random(in: 1...3)
                    
                    // 前回と同じ結果のときは再度ランダム
                    // 異なる結果のときは、repeatを抜ける
                } while answerNumber == newAnswerNumber
                
                // 新しいじゃんけんの結果を格納
                answerNumber = newAnswerNumber
            }) {
                // {じゃんけんをする}ボタン　ここまで
                Text("ジャンケンをする")
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .font(.title)
                    .background(Color.pink)
                    .foregroundColor(Color.white)
            } // {じゃんけんをする！}ボタンはここまで
            
        } // VStackここまで
    } // bodyここまで
} // CountViewここまで

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
