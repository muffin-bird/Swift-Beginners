//
//  ContentView.swift
//  MyCamera
//
//  Created by muffin man on 2021/07/06.
//

import SwiftUI

struct ContentView: View {
    // 撮影する写真を保持する状態変数
    @State var captureImage: UIImage? = nil
    
    // 撮影画面のsheet
    @State var isShowSheet = false
    
    // フォトライブラリーかカメラかを保持する状態変数
    @State var isPhotolibrary = false
    
    // ActionSheetのsheet
    @State var isShowAction = false
    
    var body: some View {
        // 縦方向にレイアウト
        VStack {
            // スペース追加
            Spacer()
            // 「カメラを起動する」 ボタン
            Button(action: {
                // ボタンをタップしたときのアクション
                // 撮影写真を初期化する
                captureImage = nil
                // ActionSheet を表示する
                isShowAction = true
            }) {
                // テキスト表示
                Text("カメラを起動する")
                    // 横幅いっぱい
                    .frame(maxWidth: .infinity)
                    // 高さ50ポイントを指定
                    .frame(height: 50)
                    // 文字列をセンタリング指定
                    .multilineTextAlignment(.center)
                    // 背景を青色に指定
                    .background(Color.blue)
                    // 文字色を白に指定
                    .foregroundColor(.white)
            } // 「カメラを起動する」 ボタン ここまで
            //上下左右に余白を設定
            .padding()
            // sheetを表示
            // isPresetedで指定した状態変数がtrueのとき実行
            .sheet(isPresented: $isShowSheet) {
                if let unwrapCaptureImage = captureImage{
                    // 撮影した写真がある→EffectViewを表示する
                    EffectView(
                        isShowSheet: $isShowSheet,
                        captureImage: unwrapCaptureImage)
                } else {
                    // フォトライブラリーが選択された
                    if isPhotolibrary {
                        // PHPickerViewController(フォトライブラリー)を表示
                        PHPickerView(
                            isShowSheet: $isShowSheet,
                            captureImage: $captureImage)
                    } else {
                        // UIImagePickerController (写真撮影) をsheetを表示
                        ImagePickerView(
                            isShowSheet: $isShowSheet,
                            captureImage: $captureImage)
                    }
                }
            } // 「カメラを起動する」 ボタンのsheetここまで
            // 状態変数:$isShowActionに変化があったら実行
            .actionSheet(isPresented: $isShowAction) {
                // ActionSheetを表示する
                ActionSheet(title: Text("確認"),
                            message: Text("選択してください"),
                            buttons: [
                                .default(Text("カメラ"), action: {
                                    // カメラ選択
                                    isPhotolibrary = false
                                    // カメラが利用可能かチェック
                                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                        print("カメラは利用できます")
                                        // カメラが使えるなら、isShowSheetを true
                                        isShowSheet = true
                                    } else {
                                        print("カメラは利用できません")
                                    }
                                }),
                                .default(Text("フォトライブラリー"), action: {
                                    // フォトライブラリーを選択
                                    isPhotolibrary = true
                                    // isShowsheetをtrue
                                    isShowSheet = true
                                }),
                                // キャンセル
                                .cancel(),
                ]) // ActionSheet ここまで
            } // .actionSheet ここまで
        } // VStack ここまで
    } // body ここまで
} // CountentView ここまで

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
