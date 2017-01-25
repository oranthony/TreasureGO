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
    
    
    
    //We keep the map centered on the pplayer
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        _ = userLocation.coordinate.longitude;
        _ = userLocation.coordinate.latitude;
        
        centerMapOnLocation(location: userLocation.coordinate)
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

}

