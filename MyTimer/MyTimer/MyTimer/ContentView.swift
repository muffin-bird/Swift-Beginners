//
//  ContentView.swift
//  MyTimer
//
//  Created by muffin man on 2021/07/04.
//

import SwiftUI

struct ContentView: View {
    // タイマーの変数を作成
    @State var timerHandler : Timer?
    
    // 経過時間の変数を作成
    @State var count = 0
    
    // 永続化する秒数設定
    @AppStorage("timer_value") var timerValue = 10
    
    // アラート表示有無
    @State var showAlert = false
    
    var body: some View {
        NavigationView {
            // 奥から手前にレイアウト
            ZStack {
                // 背景画像
                Image("backgroundTimer")
                    // リサイズ
                    .resizable()
                    // セーフエリアに超えて画面全体を配置する
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    // アスペクト比
                    .aspectRatio(contentMode: .fill)
                
                // 垂直にレイアウト
                // Viewの間隔を30にする
                VStack(spacing: 30.0) {
                    // テキストを表示
                    Text("残り\(timerValue - count)秒")
                        // 文字サイズを指定
                        .font(.largeTitle)
                    
                    // 水平にレイアウト
                    HStack {
                        // スタートボタン
                        Button(action: {
                            // ボタンをタップしたときのアクション
                            // タイマーをカウントダウンする関数を呼び出す
                            startTimer()
                        }) {
                            // テキストを表示する
                            Text("スタート")
                                // 文字サイズを指定
                                .font(.title)
                                // 文字色を白に指定
                                .foregroundColor(.white)
                                // 幅高さを140に指定
                                .frame(width: 140, height: 140)
                                // 背景を設定
                                .background(Color("startColor"))
                                // 円形に切り抜く
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        } // スタートボタンここまで
                        
                        Button(action: {
                            // ボタンをタップしたときのアクション
                            //timerHandlerをアンラップしてunwrapedTimerHandlerに代入
                            if let unwrapedTimerHandler = timerHandler {
                                // もしタイマーが実行中だったらスタートしない
                                if unwrapedTimerHandler.isValid == true {
                                    // タイマー停止
                                    unwrapedTimerHandler.invalidate()
                                }
                            }
                        }) {
                            // テキストを表示する
                            Text("ストップ")
                                // 文字サイズを指定
                                .font(.title)
                                // 文字色を白に指定
                                .foregroundColor(.white)
                                // 幅高さを140に指定
                                .frame(width: 140, height: 140)
                                // 背景を設定
                                .background(Color("stopColor"))
                                // 円形に切り抜く
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        } // ストップボタンここまで
                    } // HStack ここまで
                } // VStack ここまで
            } // ZStack ここまで
            
            // 画面が表示されるときに実行
            .onAppear {
                // 経過時間の変数を初期化
                count = 0
            } // .onApper ここまで
            // ナビゲーションバーにボタン追加
            .navigationBarItems(trailing:
                // ナビゲーション移動
                NavigationLink(destination: SettingView()) {
                    // テキスト表示
                    Text("秒数設定")
                } // NavigationLink ここまで
            ) // .navigationBarItems ここまで
            // 状態変数showAlertがtrueになったときに実行される
            .alert(isPresented: $showAlert) {
                // アラートを表示するためのレイアウト
                // アラートを表示する
                Alert(title: Text("終了"),
                    message: Text("タイマー終了時間です"),
                    dismissButton: .default(Text("OK")))
                
            } // .alert ここまで
        } // NavigationView ここまで
    } // body ここまで

    // 1秒毎に実行されてカウントダウンする
    func CountDownTimer() {
        // 経過時間に+1する
        count += 1
        
        // 残り時間が0以下のとき、タイマーを止める
        if timerValue - count <= 0 {
            // タイマー停止
            timerHandler?.invalidate()
            
            // アラートを表示する
            showAlert = true
        }
    } // CountDownTimer ここまで
    
    // タイマーをカウントダウン開始する変数
    func startTimer() {
        // timerHandlerをアンラップしてunwrapedTimerHandlerに代入
        if let unwrapedTimerHandler = timerHandler {
            // もしタイマーが実行中だったらスタートしない
            if unwrapedTimerHandler.isValid == true {
                // 何もしない
                return
            }
        }
        
        // 残り時間が0以下のとき、経過時間を0に初期化する
        if timerValue - count <= 0 {
            // 経過時間を0にする
            count = 0
        }
        
        // タイマースタート
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            // タイマー実行時に呼び出される
            // 1秒毎に実行されてカウントダウンする関数を実行
            CountDownTimer()
        }
    } // startTimer ここまで
} // ContentView ここまで

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        }
    }
