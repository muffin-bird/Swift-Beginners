//
//  MapView.swift
//  MyMap
//
//  Created by muffin man on 2021/07/03.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    // 検索キーワード
    let searchKey:String
    
    // マップ種類
    let mapType: MKMapType

    // 表示する View を作成するときに実行
    func makeUIView(context: Context) -> MKMapView {
        
        // MKMapView のインスタンス生成
        MKMapView()
        
    } // makeUIView ここまで
    
    // 表示した View が更新されるたびに実行
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        // 入力された文字をデバックエリアに表示
        print(searchKey)
        
        // マップ種類の設定
        uiView.mapType = mapType
        
        // CLGeocorderインスタンスを収得
        let geocoder = CLGeocoder()
        
        // 入力された文字から位置情報を収得
        geocoder.geocodeAddressString(
            searchKey ,
            completionHandler: { (placemarks,error) in
        
            // リクエストの結果が存在し、1件目の情報から位置情報を取り出す
            if let unwrapPlacemarks = placemarks ,
               let firstPlacemark = unwrapPlacemarks.first ,
               let location = firstPlacemark.location {
        
                //位置情報から緯度経度をtargetcoordinateに取り出す
                let targetCoordinate = location.coordinate
                // 緯度経度をデバックエリアに表示
                print(targetCoordinate)
                
                // MKPointAnnotationインスタンスを収得し、ピンを作成
                let pin = MKPointAnnotation()
                
                // ピンの置く場所に緯度経度を設定
                pin.coordinate = targetCoordinate
                
                // ピンのタイトル設定
                pin.title = searchKey
                
                // ピンを地図に置く
                uiView.addAnnotation(pin)
                
                // 緯度経度を中心にして半径500mの範囲を表示
                uiView.region = MKCoordinateRegion(
                    center: targetCoordinate,
                    latitudinalMeters: 500.0,
                    longitudinalMeters: 500.0)
                
            } // if ここまで
        }) // gecorder ここまで
    } // updateUIView ここまで
} // MapView ここまで

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(searchKey: "東京タワー", mapType: .standard)
    }
}
