//
//  MapViewController.swift
//  RestaurantSearcherGPS
//
//  Created by 洞井僚太 on 2024/02/17.
//  検索条件入力画面
//  当初mapView上に検索結果を入力することも兼任していたが、要求仕様と異なるので撤去する

import Foundation
import MapKit
import CoreLocation
import CoreLocationUI

class MapViewController: UIViewController,UITextFieldDelegate{
    
    
    var locationManager = CLLocationManager()
    var response : hotpepperResult?
    var request = RequestRestaurant()
    enum MenuType: Int {
            case threeM = 1
            case fiveM = 2
            case oneKM = 3
            case twoKM = 4
            case threeKM = 5
        }
    private let rangeItems = ["300m","500m","1km","2km","3km"]
    var rangeVal =  MenuType.threeM
    var inputText : String!
    

    @IBOutlet weak var inputField: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var rangePicker: UIButton!
    
   
    
    @IBAction func searchButton(_ sender: Any) {
        requestCurrentLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputField.delegate = self
        //test.delegate = self
        setCenterCurrentLocation()
        self.configureRangePicker()
        
    }
    
    
    private func setCenterCurrentLocation(){
        var region: MKCoordinateRegion = mapView.region
        region.center = CLLocationCoordinate2D(latitude: self.locationManager.location!.coordinate.latitude,
                                               longitude: self.locationManager.location!.coordinate.longitude)
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region, animated: true)
    }
    
    private func requestCurrentLocation() {
        self.locationManager.startUpdatingLocation()
        //request.latitude = self.locationManager.location!.coordinate.latitude
        //request.longitude = self.locationManager.location!.coordinate.longitude
        request.getHotpepperResponse(
            latitude: locationManager.location!.coordinate.latitude,
            longitude: locationManager.location!.coordinate.longitude,
            range: rangeVal.rawValue,
            inputText: inputField.text,
            callBackClosure: receiveResult
        )
        
    }
    private func receiveResult(){
        performSegue(withIdentifier: "toRestaurantResultView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRestaurantResultView" {
            let nextVC = segue.destination as! RestaurantResultViewController
            nextVC.locationManager = locationManager
            nextVC.response = request.result
        }
    }
    
    func setRegion(range:Int){
        var region: MKCoordinateRegion = mapView.region
        region.center = CLLocationCoordinate2D(latitude: self.locationManager.location!.coordinate.latitude,
                                               longitude: self.locationManager.location!.coordinate.longitude)
        switch range{
        case 1:
            region.span.latitudeDelta = 0.004
            region.span.longitudeDelta = 0.004
            break
        case 2:
            region.span.latitudeDelta = 0.006
            region.span.longitudeDelta = 0.006
            break
        case 3:
            region.span.latitudeDelta = 0.0132
            region.span.longitudeDelta = 0.0132
            break
        case 4:
            region.span.latitudeDelta = 0.0266
            region.span.longitudeDelta = 0.0266
            break
        default:
            region.span.latitudeDelta = 0.04
            region.span.longitudeDelta = 0.04
            break
            
        }
        
        mapView.setRegion(region, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // キーボードを閉じる
            textField.resignFirstResponder()
            
            return true
        }

    
    private func configureRangePicker() {
        var actions = [UIMenuElement]()
        // HIGH
        actions.append(UIAction(title: rangeItems[0], image: nil, state: self.rangeVal == MenuType.threeM ? .on : .off,
                                handler: { (_) in
                                    self.rangeVal = .threeM
                                    // UIActionのstate(チェックマーク)を更新するためにUIMenuを再設定する
                                    self.configureRangePicker()
                                }))
        // fiveM
        actions.append(UIAction(title: rangeItems[1], image: nil, state: self.rangeVal == MenuType.fiveM ? .on : .off,
                                handler: { (_) in
                                    self.rangeVal = .fiveM
                                    // UIActionのstate(チェックマーク)を更新するためにUIMenuを再設定する
                                    self.configureRangePicker()
                                }))
        // oneKM
        actions.append(UIAction(title: rangeItems[2], image: nil, state: self.rangeVal == MenuType.oneKM ? .on : .off,
                                handler: { (_) in
                                    self.rangeVal = .oneKM
                                    // UIActionのstate(チェックマーク)を更新するためにUIMenuを再設定する
                                    self.configureRangePicker()
                                }))
        actions.append(UIAction(title: rangeItems[3], image: nil, state: self.rangeVal == MenuType.twoKM ? .on : .off,
                                handler: { (_) in
                                    self.rangeVal = .twoKM
                                    // UIActionのstate(チェックマーク)を更新するためにUIMenuを再設定する
                                    self.configureRangePicker()
                                }))
        actions.append(UIAction(title: rangeItems[4], image: nil, state: self.rangeVal == MenuType.threeKM ? .on : .off,
                                handler: { (_) in
                                    self.rangeVal = .threeKM
                                    // UIActionのstate(チェックマーク)を更新するためにUIMenuを再設定する
                                    self.configureRangePicker()
                                }))

        // UIButtonにUIMenuを設定
        rangePicker.menu = UIMenu(title: "", options: .displayInline, children: actions)
        // こちらを書かないと表示できない場合があるので注意
        rangePicker.showsMenuAsPrimaryAction = true
        // ボタンの表示を変更
        // APIのリクエストで求められるrangeの値は1~5なので、rawValueをそれに合わせた結果、配列外参照を踏むので1引く
        rangePicker.setTitle(rangeItems[self.rangeVal.rawValue-1], for: .normal)
        
        setRegion(range: self.rangeVal.rawValue)
    }


    
    
    /*private func setPinOnMapView(){
        //print(request.result?.results.shop[0].id)
        if (request.result?.results.results_available)! > 1{
            let results = request.result?.results
            // 店の情報を取り出し、ピンとしてマップ上に表示
            for shop in (results?.shop)!
            {
                let pin = MKPointAnnotation()
                // ピンのタイトル・サブタイトルをセット
                pin.title = shop.name
                //pin.subtitle = "サブタイトル"
                        // ピンに一番上で作った位置情報をセット
                pin.coordinate.latitude = Double(shop.lat)
                pin.coordinate.longitude = Double(shop.lng)
                        // mapにピンを表示する
                self.mapView.addAnnotation(pin)
                print(pin.coordinate)
            }
        }*/
        
        
        
    }
    
    extension MapViewController: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else { return }
            locationManager.stopUpdatingLocation()
            //self.response = RequestRestaurant()
            //request.latitude = location.coordinate.latitude
            //request.longitude = location.coordinate.longitude
            //request.getHotpepperResponse(callBackClosure: setResponse)
            var region: MKCoordinateRegion = mapView.region
             region.center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
             longitude: location.coordinate.longitude)
             region.span.latitudeDelta = 0.02
             region.span.longitudeDelta = 0.02
             mapView.setRegion(region, animated: true)
        }
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
                 print("error:: \(error.localizedDescription)")
            }
    }

