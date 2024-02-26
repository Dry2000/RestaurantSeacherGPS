//
//  getImageByURL.swift
//  RestaurantSearcherGPS
//
//  Created by 洞井僚太 on 2024/02/18.
//

import Foundation
import UIKit
    
func getImageByURL(url: String) -> UIImage{
    //Todo:あとで非同期で画像を読み出すように変更する
    let url = URL(string: url)
    do {
        let data = try Data(contentsOf: url!)
        return UIImage(data: data)!
    } catch let err {
        print("Error : \(err.localizedDescription)")
    }
    return UIImage()
}
        
