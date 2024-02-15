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

class ViewController: UIViewController {
    
   // @IBOutlet weak var mapView: MKMapView!
    var response : hotpepperResult?
    var request = RequestRestaurant()
    
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
        self.locationManager.startUpdatingLocation()
    }
    func setResponse(){
            response = request.result
        //print(response?.results.api_version)
        }

}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationManager.stopUpdatingLocation()
        //self.response = RequestRestaurant()
        request.latitude = location.coordinate.latitude
        request.longitude = location.coordinate.longitude
        request.getHotpepperResponse(callBackClosure: setResponse)
        /*var region: MKCoordinateRegion = mapView.region
        region.center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                               longitude: location.coordinate.longitude)
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region, animated: true)*/
    }
}



