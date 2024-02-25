//
//  RequestRestaurant.swift
//  RestaurantSearcherGPS
//
//  Created by 洞井僚太 on 2024/02/14.
//  APIにリクエストする関数

import Foundation
import Alamofire
import UIKit

class RequestRestaurant{
    var result:hotpepperResult?
    // デコードに失敗することを記憶する アラート表示する際に判定として利用
    var failDecode = false

    func getHotpepperResponse(latitude:Double,longitude:Double,range:Int,inputText:String?,number:Int,callBackClosure:@escaping () -> Void){
        let apiKey = Key()
        var accessResponse:hotpepperResult?
        var url = ""
        // 検索条件の欄が空欄の場合、リクエストのurlをkeywordが引数に含まれない文字列とする
        if inputText == nil{
             url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=\(apiKey.key!)&lat=\(latitude)&lng=\(longitude)&range=\(range)&order=4&format=json"
        }
        else{
             url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=\(apiKey.key!)&lat=\(latitude)&lng=\(longitude)&range=\(range)&keyword=\(inputText!)&order=4&format=json"
        }
        AF.request(url,method: .get).responseDecodable(of:hotpepperResult.self ){response in
            switch response.result{
            case .success:
                let decoder:JSONDecoder = JSONDecoder()
                do{
                    accessResponse = try decoder.decode(hotpepperResult.self,from:response.data!)
                    self.result = accessResponse
                    print("success")
                    callBackClosure()
                }catch{
                    
                    print("JSON convert failed",error.localizedDescription)
                }
                break
            case .failure(let ERROR):
                    /*if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)")
                    }*/
                /* shopのパラメータであるparty_capacityが""で帰ってくる現象を確認、
                 なお、party_capacity自体はInt型なので、JSONDecorderではデコードできない。
                 一旦Alertを出して通信に問題があったことを通知する方針で対処
                 */
                self.failDecode = true
                print(ERROR)
                callBackClosure()
                break
            }
        }
    }
}
