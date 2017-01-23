//
//  FirstViewController.swift
//  Test1
//
//  Created by anthony loroscio on 22/12/2016.
//  Copyright © 2016 anthony loroscio. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON

class FirstViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var stepContentTextView: UITextView!
    @IBOutlet weak var hintContentTextView: UITextView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var hintButton: UIButton!
    
    //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hintContentTextView))
    
    //let locationManager = CLLocationManager()
    //var myLocation:CLLocationCoordinate2D?
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    let regionRadius: CLLocationDistance = 1000
    
    var segueInfo: Int = -1
    var currentStep = 0
    var json:JSON = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hintButton.addTarget(self, action: #selector(FirstViewController.showHint), for: .touchUpInside)
        
        //Setup our Location Manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        //Setup our Map View
        map.delegate = self
        //map.mapType = MKMapType.Satellite
        map.showsUserLocation = true
        
        //Apply the center
        //centerMapOnLocation(location: initialLocation)
        
        
        //Load json
        let path = Bundle.main.path(forResource: "document", ofType: "json")
        let jsonData : NSData = NSData(contentsOfFile: path!)!
        
        json = JSON(data: jsonData as Data) // Note: data: parameter name
        
        refreshStepContent()
        
        //centerMapOnLocation(location: map.userLocation.coordinate)
        
        //We hide the hint
        self.hintContentTextView.isHidden = true
        
    }

    //Refresh the step indicator
    func refreshStepContent(){
        stepContentTextView.text = json["list"][segueInfo]["content"][currentStep]["title"].string
        //hintContentTextView.text = "Tap to get a hint"
        hintContentTextView.text = json["list"][segueInfo]["content"][currentStep]["hint"].string
    }
    
    func showHint(){
        print("we show hint")
        self.hintContentTextView.isHidden = false
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    /*func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        //theLabel.text = "\(locations[0])"
        myLocations.append(locations[0] as! CLLocation)
        
        let spanX = 0.7
        let spanY = 0.7
        var newRegion = MKCoordinateRegion(center: map.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        map.setRegion(newRegion, animated: true)
        
        //Save the previous location
        /*if (myLocations.count > 1){
            var sourceIndex = myLocations.count - 1
            var destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            var polyline = MKPolyline(coordinates: &a, count: a.count)
            map.add(polyline)
        }*/
    }*/
    
    //If we want to create a path with the previous locations
    /*func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return nil
    }*/
    
    /*func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }*/
    


}

