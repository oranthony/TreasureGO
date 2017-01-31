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
    
    
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    let regionRadius: CLLocationDistance = 1000
    
    var segueInfo: Int = -1
    var currentStep = 0
    var json:JSON = []
    var hasCenterdMap = false
    
    var userLocation:CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.map.delegate = self
        
        //detect when player want a hint
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
        
        
        //Load json
        let path = Bundle.main.path(forResource: "document", ofType: "json")
        let jsonData : NSData = NSData(contentsOfFile: path!)!
        json = JSON(data: jsonData as Data)
        
        //We display the step enigma
        refreshStepContent()
        
        //We hide the hint
        self.hintContentTextView.isHidden = true
        
    }
    
    func doResetMap(){
        centerMapOnLocation(location: userLocation.coordinate)
        
        //We go back to the first view
        tabBarController?.selectedIndex = 0
    }
    
    //We keep the map centered on the pplayer
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0]
        _ = userLocation.coordinate.longitude;
        _ = userLocation.coordinate.latitude;
        
        if(hasCenterdMap == false){
            hasCenterdMap = true
            doResetMap()
        }
        
        
    }
    
    
    
    //Set the center of the map on the passed location
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    
    
    //Refresh the step indicator
    func refreshStepContent(){
        
        stepContentTextView.text = json["list"][segueInfo]["content"][currentStep]["title"].string
        
        hintContentTextView.text = json["list"][segueInfo]["content"][currentStep]["hint"].string
    }
    
    
    //Return the URL of the current monument's page
    func getUrl() -> JSON{
        
        return json["list"][segueInfo]["content"][currentStep]
        
    }
    
    
    //We display the textView with the hint
    func showHint(){
        self.hintContentTextView.isHidden = false
    }
    
    
    func goNextStep(){
        
        //We hide the hint
        self.hintContentTextView.isHidden = true
        
        //Set the step to the next step
        currentStep += 1
        
        //Check if final step
        if(json["list"][segueInfo]["content"][currentStep].exists()){
            
            refreshStepContent()
            
        }else{
            
            let alert = UIAlertController(title: "Well done !", message: "The treasure hunt is finished", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Go to home screen", style: UIAlertActionStyle.default, handler: { action in
                self.backToHomeScreen()}
            ))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        //We go back to the first view
        tabBarController?.selectedIndex = 0
        
    }
    
    func backToHomeScreen(){
        let homeController = self.storyboard!.instantiateViewController(withIdentifier: "Home")
        UIApplication.shared.keyWindow?.rootViewController = homeController
    }
    
    
    func drawPath(){
        
        let latitude = json["list"][segueInfo]["content"][currentStep]["latitude"].double
        
        let longitude = json["list"][segueInfo]["content"][currentStep]["longitude"].double
        
        let sourceLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let destinationLocation = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let monumentName = json["list"][segueInfo]["content"][currentStep]["name"].string
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = monumentName
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        
        
        self.map.showAnnotations([destinationAnnotation], animated: true )
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.map.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.map.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
        
        
        //We go back to the first view
        tabBarController?.selectedIndex = 0
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        
        return renderer
    }

}

