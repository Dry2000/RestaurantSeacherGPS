//
//  RestaurantDetailViewController.swift
//  RestaurantSearcherGPS
//
//  Created by 洞井僚太 on 2024/02/19.
//  店舗詳細画面

import Foundation
import UIKit

class RestaurantDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var shop : shop!
    
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
        switch indexPath.row{
        case 1:
            content.text = shop.open
            break
        case 2:
            content.text = shop.address
            break
        case 3:
            content.image = UIImage(systemName: "location.circle")
            content.text = "現在地から経路を調べる"
            break
        default: break
            
            
        }
        cell.contentConfiguration = content
        return cell
    }
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == (shop?.recipeMaterial.count)!+1{
            self.performSegue(withIdentifier: "toOriginalPage", sender: Any?.self)
        }
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "toOriginalPage") {
                let vc2:originalPageViewController = (segue.destination as? originalPageViewController)!
                vc2.targetUrl = shop?.recipeUrl
            }
        }*/
}
