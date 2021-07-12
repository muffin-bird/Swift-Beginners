//
//  PHPickerView.swift
//  MyCamera
//
//  Created by muffin man on 2021/07/12.
//

import SwiftUI
import PhotosUI

struct PHPickerView: UIViewControllerRepresentable {
    
    // sheetが表示されているか
    @Binding var isShowSheet: Bool
    
    // フォトライブラリーから読み込む写真
    @Binding var captureImage: UIImage?
    
    // coodinator でコントローラの delegate を管理
    class Coordinator: NSObject,
                       PHPickerViewControllerDelegate {
        // PHPickerView型の変数を用意
        var parent: PHPickerView
        // イニシャライズ
        init(parent: PHPickerView) {
            self.parent = parent
        }
        // フォトライブラリーで写真を選択・キャンセルしたときに実行される
        // delegate メソッド、必ず必要
        func picker(
                _ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
            
            // 写真は1つだけ選べる設定なので、最初の1件を指定
            if let result = results.first {
                // UIImage型の写真のみ非同期で収得
                result.itemProvider.loadObject(ofClass: UIImage.self) {
                    (image, error) in
                    // 写真が収得できたら
                    if let unwrapImage = image as? UIImage {
                        // 選択された写真を追加する
                        self.parent.captureImage = unwrapImage
                    } else {
                        print("使用できる写真がないです")
                    }
                }
                // sheetを閉じない
                parent.isShowSheet = true
            } else {
                print("選択された写真がないです")
                // sheetを閉じる
                parent.isShowSheet = false
            }
        } // picker ここまで
    } // Coordinator ここまで
    
    // Coordinatorを生成、swiftUIによって自動的に呼び出し
    func makeCoordinator() -> Coordinator {
        // Coordinatorクラスのインスタンスを生成
        Coordinator(parent: self)
    }
    
    // Viewを生成するときに実行
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<PHPickerView>)
        -> PHPickerViewController {
        // PHPPickerViewControllerのカスタマイズ
        var configuration = PHPickerConfiguration()
        // 静止画を選択
        configuration.filter = .images
        // フォトライブラリーで選択できる枚数を1枚にする
        configuration.selectionLimit = 1
        // PHPickerViewControllerのインスタンスを生成
        let picker = PHPickerViewController(configuration: configuration)
        // delegate設定
        picker.delegate = context.coordinator
        // PHPickerViewControllerを返す
        return picker
    }
    
    // Viewが更新されたときに実行
    func updateUIViewController(
        _ uiViewController: PHPickerViewController,
        context: UIViewControllerRepresentableContext<PHPickerView>)
    {
        // 処理なし
    }
} // PHPickerView ここまで

