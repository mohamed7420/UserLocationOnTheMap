//
//  ViewController.swift
//  UserLocationOnTheMap
//
//  Created by Mohamed on 9/2/19.
//  Copyright © 2019 Mohamed74. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let regionInMeters:Double = 10000
    let locationManger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
      checkLocationPermission()
        
    }
    
    func setLocationManger(){
        
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationPermission(){
        
        if CLLocationManager.locationServicesEnabled() {
            
            setLocationManger()
            locationManger.delegate = self
            mapView.showsUserLocation = true
            checkAuthorizationChange()
            
        }else {
            
            // alert user to open his/her location permission
            
        }
        
    }
    
    func fokusOnUserLocation(){
        
        if let location = locationManger.location?.coordinate{
            
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
           
            mapView.setRegion(region, animated: true)
        }
    
    
    }
    
    func checkAuthorizationChange(){
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManger.startUpdatingLocation()
            fokusOnUserLocation()
            
            break
        case .authorizedAlways:
            break
        case .denied :
            break
        case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        default:
            break
        }
        
        
        
    }


}

extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let lastLocation = locations.last else {return}
        
        let center = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        
        mapView.setRegion(region, animated: true)
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkAuthorizationChange()
    }
    
}

