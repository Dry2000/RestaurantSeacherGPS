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
        requestRestaurant()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputField.delegate = self
        //test.delegate = self
        setCenterCurrentLocation()
        // ボタンの下方向の矢印を右側に表示したいのでボタンを左右反転させる
        rangePicker.transform = CGAffineTransform(scaleX: -1, y: 1)
        // 文字が反転するため、titleLabelを左右反転させ元に戻す、画像は左右反転しても問題ない形状なので反転しない
        rangePicker.titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
        rangePicker.imageView?.tintColor = .white
        //ボタン(rangePicker)をタップすると、検索する範囲を設定できるようにactionを追加する
        self.configureRangePicker()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(requestCurrentLocation(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    // ビューが開いた時に画面の中心を現在地に合わせる関数
    private func setCenterCurrentLocation(){
        var region: MKCoordinateRegion = mapView.region
        region.center = CLLocationCoordinate2D(latitude: self.locationManager.location!.coordinate.latitude,
                                               longitude: self.locationManager.location!.coordinate.longitude)
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region, animated: true)
    }
    
    private func requestRestaurant() {
        self.locationManager.startUpdatingLocation()
        request.getHotpepperResponse(
            latitude: locationManager.location!.coordinate.latitude,
            longitude: locationManager.location!.coordinate.longitude,
            range: rangeVal.rawValue,
            inputText: inputField.text,
            number: 1,
            callBackClosure: receiveResult
        )
        
    }
    
    //リクエストの結果を受け取ってそれによって画面遷移かアラートを表示する
    private func receiveResult(){
        // jsondecorderでエラーが発生した場合(party_capacity = "" の場合など)
        if(request.failDecode){
            let alert = UIAlertController(title: "通信に問題が発生しました", message: "大変申し訳ありませんが、通信に問題が発生し、レストランの情報を取得できませんでした。他の条件をお試しください", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                //self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            return
        }
        // 検索結果が0件だった場合
        if (request.result?.results.results_available)! < 1{
            let alert = UIAlertController(title: "条件に一致する店舗が見つかりませんでした", message: "検索条件または、範囲を再設定してください", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                //self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else{
            //上記以外の場合、検索結果一覧を表示する画面に遷移
            performSegue(withIdentifier: "toRestaurantResultView", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRestaurantResultView" {
            let nextVC = segue.destination as! RestaurantResultViewController
            nextVC.response = request.result
        }
    }
    
    //UIButtonによって選ばれた範囲によって表示範囲を変更する関数
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
    // キーボードのreturnが押された時、キーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // キーボードを閉じる
            textField.resignFirstResponder()
            
            return true
        }
    // キーボード以外の場所が押された時、キーボードを閉じる
    @objc func requestCurrentLocation(_ sender : UITapGestureRecognizer) {
        
        inputField.resignFirstResponder()
    }
    
    private func configureRangePicker() {
        var actions = [UIMenuElement]()
        // threeM
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
        rangePicker.showsMenuAsPrimaryAction = true
        // ボタンの表示を変更
        // APIのリクエストで求められるrangeの値は1~5なので、rawValueをそれに合わせた結果、配列外参照を踏むので1引く
        rangePicker.setTitle(rangeItems[self.rangeVal.rawValue-1], for: .normal)
        //選ばれた範囲によって表示範囲を変更する
        setRegion(range: self.rangeVal.rawValue)
    }

    }
    
    extension MapViewController: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else { return }
            locationManager.stopUpdatingLocation()
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

