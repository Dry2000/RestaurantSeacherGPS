//
//  makePath.swift
//  RestaurantSearcherGPS
//
//  Created by 洞井僚太 on 2024/02/23.
//

import Foundation
import CoreLocation
import MapKit

class PathViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate{
    var locationManager = CLLocationManager()
    var shopInfo:shop!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        setCenterCurrentLocation()
        let destLoc = CLLocationCoordinate2D(latitude:CLLocationDegrees(shopInfo!.lat), longitude: CLLocationDegrees(shopInfo!.lng))
        
        showRoute(currentLocation: locationManager.location!.coordinate, destLocation: destLoc)
        //locationManager.requestWhenInUseAuthorization()
       // createLocationButton()
    }
    
    
    
    private func setCenterCurrentLocation(){
        var region: MKCoordinateRegion = mapView.region
        region.center = CLLocationCoordinate2D(latitude: self.locationManager.location!.coordinate.latitude,
                                               longitude: self.locationManager.location!.coordinate.longitude)
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region, animated: true)
    }
    func showRoute(currentLocation: CLLocationCoordinate2D,destLocation: CLLocationCoordinate2D) {
        
        let sourcePlaceMark = MKPlacemark(coordinate: currentLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destLocation)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            let route = directionResonse.routes[0]
            //self.route = route
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            let time = route.expectedTravelTime / 60
            print("\(time)分かかります")
            //self.showToast(message: "所要時間は「" + String(time.rounded()) + "」分です。", font: .systemFont(ofSize: 12.0))
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 4.0
            return renderer
        }
}
