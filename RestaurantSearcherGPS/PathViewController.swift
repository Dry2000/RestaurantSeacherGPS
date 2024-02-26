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
    var shopInfo : shop!
    var route : MKRoute!
    var selectedWay = 0
    
    @IBOutlet weak var choiceWay: UISegmentedControl!
    
    @IBAction func backRestaurantView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        setCenterCurrentLocation()
        let destLoc = CLLocationCoordinate2D(latitude:CLLocationDegrees(shopInfo!.lat), longitude: CLLocationDegrees(shopInfo!.lng))
        // 対応するレストランへの経路をmapview上に表示する
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
    // 対応するレストランへの経路をmapview上に表示する
    func showRoute(currentLocation: CLLocationCoordinate2D,destLocation: CLLocationCoordinate2D) {
        let currentPin = MKPointAnnotation()
        currentPin.title = "出発地点"
        currentPin.coordinate = currentLocation
        let destinationPin = MKPointAnnotation()
        destinationPin.title = self.shopInfo.name
        destinationPin.coordinate = destLocation
        // 現在地と、レストランの場所へピンを刺す
        self.mapView.addAnnotation(currentPin)
        self.mapView.addAnnotation(destinationPin)
        
        let sourcePlaceMark = MKPlacemark(coordinate: currentLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destLocation)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        // 画面のSegmentedControlの内容によって歩きか車か経路検索を決定する
        if selectedWay == 0{
            directionRequest.transportType = .walking
        }else{
            directionRequest.transportType = .automobile
        }
        
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResponse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            let route = directionResponse.routes[0]
            //self.route = route
            //検索した経路をmapView上に表示する
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            // 経路にかかる時間を分単位で表示する
            let time = Int(route.expectedTravelTime / 60)
            destinationPin.title = "\(self.shopInfo.name)\n所要時間:\(time)分"
            //print("\(time)分かかります")
            //self.showToast(message: "所要時間は「" + String(time.rounded()) + "」分です。", font: .systemFont(ofSize: 12.0))
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            //let route: MKPolyline = overlay as MKPolyline
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
        }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        //segmentedControlにて選択された値が変更された場合、マップのピンと、表示された経路を削除する
        selectedWay = sender.selectedSegmentIndex
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        let destLoc = CLLocationCoordinate2D(latitude:CLLocationDegrees(shopInfo!.lat), longitude: CLLocationDegrees(shopInfo!.lng))
        //選択された値に対応する交通手段を用いた場合の経路を検索し、表示する。
        showRoute(currentLocation: locationManager.location!.coordinate, destLocation: destLoc)
        //print(sender.selectedSegmentIndex)
        }
    
}
