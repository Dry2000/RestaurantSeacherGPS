//
//  ViewController.swift
//  RestaurantSearcherGPS
//
//  Created by 洞井僚太 on 2024/02/14.
//  最初に表示される画面

import UIKit
import MapKit
import CoreLocation
import CoreLocationUI

class ViewController: UIViewController,CLLocationManagerDelegate{
    
    // @IBOutlet weak var mapView: MKMapView!
    
    
    @IBAction func moveMapView(_ sender: Any) {
        
        performSegue(withIdentifier: "toMapView", sender: self)
    }
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //任意の箇所をタップすると検索画面に遷移
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(requestCurrentLocation(_:)))
        self.view.addGestureRecognizer(tapGesture)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
       // createLocationButton()
    }
    
    
    @objc func requestCurrentLocation(_ sender : UITapGestureRecognizer) {
        
        performSegue(withIdentifier: "toMapView", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapView" {
            let nextVC = segue.destination as! MapViewController
            nextVC.locationManager = locationManager
        }
        
    }

}


