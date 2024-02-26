//
//  RestaurantDetailViewController.swift
//  RestaurantSearcherGPS
//
//  Created by 洞井僚太 on 2024/02/19.
//  店舗詳細画面

import Foundation
import UIKit

class RestaurantDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var shop : shop!
    
    
    @IBAction func backResultView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var shopName: UILabel!
    
    @IBOutlet weak var shopImage: UIImageView!
    
    @IBOutlet weak var shopInfoTable: UITableView!
    override func viewDidLoad() {
        shopName.text = shop?.name
        shopName.lineBreakMode = .byCharWrapping
        shopName.numberOfLines = 0
        shopImage.image = getImageByURL(url:(shop?.photo.pc.m)!)
        shopInfoTable.delegate = self
        shopInfoTable.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4//(shop?.recipeMaterial.count)!+2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        var content = cell.defaultContentConfiguration()
        //取得した各情報をtableViewのテキストとして表示する
        switch indexPath.row{
            case 0:
                content.text = shop.open
                break
            case 1:
                content.text = "住所:\(shop.address)"
                break
            case 2:
                if shop.budget.average == ""{
                    content.text = "予算の情報を、お店が提供しておりません"
                }else{
                    content.text = "予算:\(shop.budget.average!)"
                }
                
                break
            case 3:
            // ここだけ、次の画面に遷移するための行
                content.image = UIImage(systemName: "location.circle")
                content.text = "現在地から経路を調べる"
                break
            default: break
            
            
        }
        cell.contentConfiguration = content
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3{
            // この行を選択した場合、対応するレストランへの経路を表示するビューへ移動する
            self.performSegue(withIdentifier: "toPathView", sender: Any?.self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toPathView") {
            let nextVC:PathViewController = (segue.destination as? PathViewController)!
            nextVC.shopInfo = shop
        }
    }
}
