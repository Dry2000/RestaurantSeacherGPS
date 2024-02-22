//
//  RequestRestaurant.swift
//  RestaurantSearcherGPS
//
//  Created by 洞井僚太 on 2024/02/14.
//

import Foundation
import Alamofire
import UIKit

class RequestRestaurant{
    var result:hotpepperResult?
    var failDecode = false
    //var latitude:Double!
    //var longitude:Double!
    func getHotpepperResponse(latitude:Double,longitude:Double,range:Int,inputText:String?,number:Int,callBackClosure:@escaping () -> Void){
        let apiKey = Key()
        var access_resp:hotpepperResult?
        var url = ""
        if inputText == nil{
             url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=\(apiKey.key!)&lat=\(latitude)&lng=\(longitude)&range=\(range)&order=4&format=json"
        }
        else{
             url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=\(apiKey.key!)&lat=\(latitude)&lng=\(longitude)&range=\(range)&keyword=\(inputText!)&order=4&format=json"
        }
        AF.request(url,method: .get).responseDecodable(of:hotpepperResult.self ){response in
            switch response.result{
            case .success:
                    /*let shiftJisJsonString = String(data: response.data!, encoding: .shiftJIS)
                    let utf8Json = shiftJisJsonString!.data(using: .utf8)
                    print(value)
                    let json = JSON(value)
                    print("ha")*/
                   // print(json)
                let decoder:JSONDecoder = JSONDecoder()
                do{
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        //print("Data: \(utf8Text)")
                    }
                    access_resp = try decoder.decode(hotpepperResult.self,from:response.data!)
                    self.result = access_resp
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
                    //print("test")
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
