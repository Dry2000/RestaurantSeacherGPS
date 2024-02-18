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

class MapViewController: UIViewController{
    var locationManager = CLLocationManager()
    var response : hotpepperResult?
    var request = RequestRestaurant()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func searchButton(_ sender: Any) {
        requestCurrentLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //locationManager.delegate = self
       // createLocationButton()
        setCenterCurrentLocation()
    }
    
   /* private func createLocationButton() {
        let button = CLLocationButton(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: self.view.frame.width/2,
                                                    height: 50))
        button.label = .currentLocation
        button.icon = .arrowFilled
        button.cornerRadius = 12
        button.center = CGPoint(x: view.center.x,
                                y: view.center.y + 300)
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(requestCurrentLocation), for: .touchUpInside)
    }*/
    
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
        request.latitude = self.locationManager.location!.coordinate.latitude
        request.longitude = self.locationManager.location!.coordinate.longitude
        request.getHotpepperResponse(callBackClosure: receiveResult)
        
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

