//
//  ViewController.swift
//  RestaurantSearcherGPS
//
//  Created by 洞井僚太 on 2024/02/14.
//

import UIKit
import MapKit
import CoreLocation
import CoreLocationUI

class ViewController: UIViewController,CLLocationManagerDelegate{
    
    // @IBOutlet weak var mapView: MKMapView!
    
    
    @IBAction func moveMapView(_ sender: Any) {
        performSegue(withIdentifier: "moveMapView", sender: self)
    }
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        createLocationButton()
    }
    
    private func createLocationButton() {
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
        
    }
    
    @objc func requestCurrentLocation() {
        //self.locationManager.startUpdatingLocation()
        performSegue(withIdentifier: "toMapViewController", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapViewController" {
            let nextVC = segue.destination as! MapViewController
            nextVC.locationManager = locationManager
        }
        
    }

}


