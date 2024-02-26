//
//  RequestResultViewController.swift
//  RestaurantSearcherGPS
//
//  Created by 洞井僚太 on 2024/02/18.
//
//受け取ったレストランの一覧を表示する画面
//検索結果画面

import Foundation
import UIKit
import CoreLocation
import CoreLocationUI

class RestaurantResultViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    var response : hotpepperResult?
    var tappedPath : Int!
        
    @IBAction func BackMapView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var RestaurantTable: UICollectionView!
    override func viewDidLoad() {

        RestaurantTable.delegate = self
        RestaurantTable.dataSource = self
        RestaurantTable.isUserInteractionEnabled = true
        RestaurantTable.allowsSelection = true

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width-10, height: self.view.frame.height/4)
        RestaurantTable.collectionViewLayout = layout
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if response == nil{
            return 1
        }
        // 表示される検索結果の数は前の画面でリクエストしたresults_returnedの値を使用する
        return (Int((response?.results.results_returned)!))!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell:UICollectionViewCell =
        collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",for: indexPath)
        if response == nil{
            return Cell
        }
        if(response!.results.shop[indexPath.row].photo.pc.m != nil){
            // Tag番号を使ってImageViewのインスタンス生成
            let imageView = Cell.contentView.viewWithTag(1) as! UIImageView
            // 画像配列の番号で指定された要素の名前の画像をUIImageとする
            //imageView.frame.size = CGSize(width: self.view.frame.width/3, height: imageView.frame.height)
            let cellImage = getImageByURL(url:(response!.results.shop[indexPath.row].photo.pc.m)!)
            // UIImageをUIImageViewのimageとして設定
            imageView.image = cellImage
        }
         
        let nameLabel = Cell.contentView.viewWithTag(2) as! UILabel
        //labelを二つ用意するとConstraintの設定が難解になったので、一旦一つのラベルにまとめて改行記号を用いる
        nameLabel.text = "\(response!.results.shop[indexPath.row].name)\n\(response!.results.shop[indexPath.row].access)"
        nameLabel.lineBreakMode = .byCharWrapping
        nameLabel.numberOfLines = 0
        // ToDo: labelの文字が見切れる問題があるので解決する
        nameLabel.adjustsFontSizeToFitWidth = true
        
        return Cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            // section数は１つ
            return 1
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // タップしたところの値を保持して、レストランの詳細画面に遷移
            tappedPath = indexPath.row
            performSegue(withIdentifier: "toRestaurantDetailView", sender: nil)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "toRestaurantDetailView") {
                let vc:RestaurantDetailViewController = (segue.destination as? RestaurantDetailViewController)!
                //タップされたところのレストランの情報を次の画面に渡す
                vc.shop = response?.results.shop[tappedPath]
                
            }
        }
}
