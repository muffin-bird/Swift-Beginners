//
//  ContentView.swift
//  MyOkashi
//
//  Created by muffin man on 2021/07/13.
//

import SwiftUI

struct ContentView: View {
    // OkashiDataを参照する状態変数
    @ObservedObject var okashiDataList = OkashiData()
    // 入力された文字列を保持する状態変数
    @State var inputText = ""
    // SafariViewの表示有無を管理する状態変数
    @State var showSafari = false
    
    var body: some View {
        // 垂直にレイアウト
        VStack {
            // 文字を受け取るTextFieldを表示する
            TextField("キーワードを入力してください", text: $inputText, onCommit: {
                // 入力直後に検索を表示する
                okashiDataList.searchOkashi(keyword: inputText)
            })
            // 上下左右に余白を空ける
            .padding()
            
            // リストを表示する
            List(okashiDataList.okashiList) { okashi in
                // ボタン
                Button(action: {
                    // SafariViewを表示する
                    showSafari.toggle()
                }) {
                    // okashiに要素を取り出して、List (一覧) を生成する
                    // 水平にレイアウト
                    HStack {
                        // 画像を表示
                        Image(uiImage: okashi.image)
                            //リサイズ
                            .resizable()
                            // アスペクト比
                            .aspectRatio(contentMode: .fit)
                            // 高さ40
                            .frame(height: 40)
                        // テキストを表示する
                        Text(okashi.name)
                    }
                } // Button ここまで
                .sheet(isPresented: self.$showSafari, content: {
                    // SafariViewを表示する
                    SafariView(url: okashi.link)
                        // 画面下部にいっぱいになるようにセーフエリア外までいっぱいに指定
                        .edgesIgnoringSafeArea(.bottom)
                })
            } // List ここまで
        } // VStack ここまで
    } // body ここまで
} // ContentView ここまで

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
