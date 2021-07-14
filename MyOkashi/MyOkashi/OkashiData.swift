//
//  OkashiData.swift
//  MyOkashi
//
//  Created by muffin man on 2021/07/13.
//

import Foundation
import UIKit

// Identifiableプロトコルを利用して、お菓子の情報をまとめる構造体
struct OkashiItem: Identifiable {
    let id = UUID()
    let name: String
    let link: URL
    let image: UIImage
}

// お菓子データ検索用クラス
class OkashiData: ObservableObject {
    
    // JSONのデータ構造
    struct ResultJson: Codable {
        // JSONのitem内のデータ構造
        struct Item: Codable {
            // お菓子の名称
            let name: String?
            // 掲載URL
            let url: URL?
            // 画像URL
            let image: URL?
        }
        // 複数要素
        let item: [Item]?
    }
    
    // お菓子のリスト (Identifiableプロトコル)
    @Published var okashiList: [OkashiItem] = []
    
    // Web API検索用メソッド 第一引数 : keyword 検索したいワード
    func searchOkashi(keyword: String) {
        //デバックエリアに出力
        print(keyword)
        
        // お菓子の検索キーワードをURLエンコードする → 他の形式に変換
        guard let keyword_encord = keyword.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) else {
            return
        }
        
        // リクエストURLの組み立て
        guard let req_url = URL(string: "https://sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encord)&max=10&order=r") else {
            return
        }
        print(req_url)
        
        // リクエストに必要な情報を生成
        let req = URLRequest(url: req_url)
        // データ転送を管理するためのセッションを生成
        let sesstion = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        // リクエストをタスクとして登録
        let task = sesstion.dataTask(with: req, completionHandler: {
            (data, responce, error) in
            // セッション終了
            sesstion.finishTasksAndInvalidate()
            // do try catch エラーハンドリング
            do {
                // JSONDecoderのインスタンス取得
                let decoder = JSONDecoder()
                // 受け取ったJSONデータをパース (解析) して格納
                let json = try decoder.decode(ResultJson.self, from: data!)
                
                // print(json)
                
                // お菓子の情報が取得できているか確認
                if let items = json.item {
                    // お菓子のリストを初期化
                    self.okashiList.removeAll()
                    // 取得しているお菓子の数だけ処理
                    for item in items {
                        // お菓子の名称、掲載URL, 画像URLをアンラップ
                        if let name = item.name ,
                            let link = item.url ,
                            let imageUrl = item.image ,
                            let imageData = try? Data(contentsOf: imageUrl) ,
                            let image = UIImage(data: imageData)?.withRenderingMode(.alwaysOriginal) {
                            
                            // 1つのお菓子を構造体でまとめて管理
                            let okashi = OkashiItem(name: name, link: link, image: image)
                            // お菓子の配列へ追加
                            self.okashiList.append(okashi)
                        }
                    }
                    
                    print(self.okashiList)
                }
            } catch {
                // エラー処理
                print("エラーが出ました")
            }
        })
        // ダウンロード開始
        task.resume()
    }
}
