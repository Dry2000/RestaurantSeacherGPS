//
//  RequestRestaurant.swift
//  RestaurantSearcherGPS
//
//  Created by 洞井僚太 on 2024/02/14.
//

import Foundation
import Alamofire
import SwiftyJSON

class RequestRestaurant{
    var result:hotpepperResult?
    var latitude:Double!
    var longitude:Double!
        func getHotpepperResponse(callBackClosure:@escaping () -> Void){
            let apiKey = Key()
            var access_resp:hotpepperResult?
            let url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=\(apiKey.key!)&lat=\(latitude!)&lng=\(longitude!)&range=5&order=4&format=json"
            AF.request(url,method: .get).responseDecodable(of:hotpepperResult.self ){response in
                switch response.result{
                case .success(let value):
                    /*let shiftJisJsonString = String(data: response.data!, encoding: .shiftJIS)
                    let utf8Json = shiftJisJsonString!.data(using: .utf8)
                    print(value)
                    let json = JSON(value)
                    print("ha")*/
                   // print(json)
                    let decoder:JSONDecoder = JSONDecoder()
                    do{
                        access_resp = try decoder.decode(hotpepperResult.self,from:response.data!)
                        self.result = access_resp
                        print("success")
                        callBackClosure()
                    }catch{
                        print(response.data!)
                        print("JSON convert failed",error.localizedDescription)
                    }
                    break
                case .failure(let ERROR):
                    /*if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)")
                        }*/
                    //print("test")
                    print(ERROR)
                    break
                }
            }
        }
}
