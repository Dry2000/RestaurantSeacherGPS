//
//  APIStruct.swift
//  RestaurantSearcherGPS
//
//  Created by 洞井僚太 on 2024/02/14.
//

import Foundation


struct hotpepperResult:Codable{
    let results:hotpepResult
}
struct hotpepResult:Codable{
    let api_version:String
    let results_available:Int!
    let results_returned:String!
    let results_start:Int!
    let shop:[shop]!
}


struct shop:Codable{
    let id:String
    let name:String
    let logo_image:String!
    let name_kana:String!
    let address:String
    let station_name:String!
    let ktai_coupon:Int!
    let large_service_area:codeAndName!
    let service_area:codeAndName!
    let large_area:codeAndName!
    let middle_area:codeAndName!
    let small_area:codeAndName!
    let lat:Float
    let lng:Float
    let genre:codeNameCatch
    let sub_genre:codeAndName!
    let budget:codeNameAVG!
    let budget_memo:String!
    let `catch`:String
    let capacity:Int!
    let access:String
    let mobile_access:String!
    let urls:PCURL
    let photo:photo
    let open:String!
    let close:String!
    let party_capacity:Int!
    let wifi:String!
    let wedding:String!
    let course:String!
    let free_drink:String!
    let free_food:String!
    let private_room:String!
    let horigotatsu:String!
    let tatami:String!
    let card:String!
    let non_smoking:String!
    let charter:String!
    let ktai:String!
    let parking:String!
    let barrier_free:String!
    let other_memo:String!
    let sommelier:String!
    let open_air:String!
    let show:String!
    let equipment:String!
    let karaoke:String!
    let band:String!
    let tv:String!
    let english:String!
    let pet:String!
    let child:String!
    let lunch:String!
    let midnight:String!
    let shop_detail_memo:String!
    let coupon_urls:couponURL!
}

struct codeAndName:Codable{
    let code:String!
    let name:String!
}

struct codeNameCatch:Codable{
    let code:String!
    let name:String
    let `catch`:String
}

struct codeNameAVG:Codable{
    let code:String!
    let name:String!
    let average:String!
}

struct PCURL:Codable{
    let pc:String!
}

struct photo:Codable{
    let pc:PCPhoto!
    let sp:SPPhoto!
}

struct PCPhoto:Codable{
    let l:String!
    let m:String!
    let s:String!
}
struct SPPhoto:Codable{
    let l:String!
    let s:String!
}

struct couponURL:Codable{
    let pc:String!
    let sp:String!
}

//
