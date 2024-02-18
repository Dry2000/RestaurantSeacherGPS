//
//  getImageByURL.swift
//  RestaurantSearcherGPS
//
//  Created by 洞井僚太 on 2024/02/18.
//

import Foundation
import UIKit
//class AsyncImageView: UIImageView {
    
func getImageByURL(url: String) -> UIImage{
    //あとで非同期で画像を読み出すように変更する
    let url = URL(string: url)
    do {
        let data = try Data(contentsOf: url!)
        return UIImage(data: data)!
    } catch let err {
        print("Error : \(err.localizedDescription)")
    }
    return UIImage()
}
        /*var request = URLRequest(url: url)
        // ローカルキャッシュが使用可能か試し、使用不可能であればネットワークから取得
        request.cachePolicy = .returnCacheDataElseLoad
        
        // ディスクに保存されるキャッシュ、認証情報、クッキーを使用
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        session.dataTask(with: request, completionHandler:
                            { (data, resp, err) in
            if((err) == nil){ //Success
                
                let image = UIImage(data:data!)
                self.image = image;
                
            }else{ //Error
                print("AsyncImageView:Error \(err?.localizedDescription)");
            }
        }).resume();*/
    
//}
