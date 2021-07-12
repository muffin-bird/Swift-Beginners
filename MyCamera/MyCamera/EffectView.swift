//
//  EffectView.swift
//  MyCamera
//
//  Created by muffin man on 2021/07/12.
//

import SwiftUI

// フィルタ名を列拳した配列
// 0.モノクロ
// 1.Chrome
// 2.Fade
// 3.Instant
// 4.Noir
// 5.Process
// 6.Tonal
// 7.Transfer
// 8.SepiaTone
let filterArray = ["CIPhotoEffectMono",
                   "CIPhotoEffectChrome",
                   "CIPhotoEffectFade",
                   "CIPhotoEffectInstant",
                   "CIPhotoEffectNoir",
                   "CIPhotoEffectProcess",
                   "CIPhotoEffectTonal",
                   "CIPhotoEffectTransfer",
                   "CISepiaTone"
]

// 選択中のエフェクト(filterArrayの添字)
var filterSelectNumber = 0

struct EffectView: View {
    
    // エフェクト編集画面 (シート) の表示有無を管理する状態変数
    @Binding var isShowSheet: Bool
    // 撮影した写真
    let captureImage: UIImage
    // 表示する写真
    @State var showImage:UIImage?
    //シェア画面 (UIActivityViewcontroller)
    // 表示有無を管理する状態変数
    @State var isShowActivity = false
    
    var body: some View {
        // 縦方向にレイアウト
        VStack {
            // スペースを追加
            Spacer()
            
            if let unwrapShowImage = showImage {
                // 表示する写真がある場合は画面に表示
                Image(uiImage: unwrapShowImage)
                    // リサイズ
                    .resizable()
                    // アスペクト比
                    .aspectRatio(contentMode: .fit)
            }
            // スペース追加
            Spacer()
            // エフェクトボタン
            Button(action: {
                // ボタンをタップしたときのアクション
                // フィルタ名を指定
                let filterName = filterArray[filterSelectNumber]
                // 次回に適用するフィルタを決めておく
                filterSelectNumber += 1
                // 最後のフィルタまで適用した場合
                if filterSelectNumber == filterArray.count {
                    // 最後の場合は、最初のフィルタに戻す
                    filterSelectNumber = 0
                }
                // ①元々の画像の回転角度を取得
                let rotate = captureImage.imageOrientation
                // ②UIImage形式の画像をCIImage形式に変換
                let inputImage = CIImage(image: captureImage)
                // ③フィルタの種別を引数で指定された種類を
                // 指定してCIFilterのインスタンスを取得
                guard let effectFilter =
                    CIFilter(name: filterName) else {
                    return
                }
                // ④フィルタ加工のパラメーターを初期化
                effectFilter.setDefaults()
                // ⑤インスタンスにフィルタ加工する元画像を設定
                effectFilter.setValue(
                    inputImage, forKey: kCIInputImageKey)
                // ⑥フィルタ加工を行う情報を生成
                guard let outputImage =
                        effectFilter.outputImage else {
                    return
                }
                // CIContextのインスタンス取得
                let ciContext = CIContext(options: nil)
                // ⑦フィルタ加工後の画像をCIContext上に描画じ、
                // 結果をcgImageとしてCGImage形式の画像を取得
                guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent)
                else {
                    return
                }
                // ⑧フィルタ加工後の画像をCGImage形式から
                // UIImage形式に変更。その際に回転角度を指定。
                showImage =
                    UIImage(cgImage: cgImage,
                            scale: 1.0,
                            orientation: rotate)
            }) {
                // テキスト表示
                Text("エフェクト")
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
            } // エフェクトボタンここまで
            // スペース追加
            .padding()
            // 「シェア」ボタン
            Button(action: {
                // ボタンをタップしたときのアクション
                // UIActivityViewController をモダール表示する
                isShowActivity = true
            }) {
                // テキスト表示
                Text("シェア")
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
            } // 「シェア」ボタンここまで
            .sheet(isPresented: $isShowActivity) {
                // UIActivityViewControllerを表示する
                ActivityView(shareItems: [showImage!.resize()!])
            }
            // スペース追加
            .padding()
            // 「閉じる」ボタン
            Button(action: {
                // ボタンをタップしたときのアクション
                // エフェクト編集画面を閉じる
                isShowSheet = false
            }) {
                // テキスト表示
                Text("閉じる")
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
            } // 「閉じる」ボタンここまで
            // スペース追加
            .padding()
        } // VStack ここまで
        // 写真が表示されるときに実行される
        .onAppear {
            // 撮影した写真を表示する写真に設定
            showImage = captureImage
        } // .onAppear ここまで
    } // body ここまで
} // EffectView ここまで
struct EffectView_Previews: PreviewProvider {
    static var previews: some View {
        EffectView(
            isShowSheet: Binding.constant(true),
            captureImage: UIImage(named: "preview_use")!)
    }
}
