//
//  FreeNavigationController.swift
//  Test1
//
//  Created by anthony loroscio on 05/02/2017.
//  Copyright © 2017 anthony loroscio. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import SwiftyJSON

class FreeNavigationController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate{
    
    
    @IBOutlet weak var map: MKMapView!
    
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    let regionRadius: CLLocationDistance = 1000
    
    var userLocation:CLLocation!
    var hasCenterdMap = false
    
    var json:JSON = []
    var jsonIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        let path = Bundle.main.path(forResource: "equipements-publics-nca", ofType: "json")
        let jsonData : NSData = NSData(contentsOfFile: path!)!
        json = JSON(data: jsonData as Data)
        
        //print(json)
        
        for (key,subJson):(String, JSON) in json {
            
            for(keyBis, subJsonBis):(String, JSON) in subJson{
            
                //print(subJsonBis["TYPE"])
                
                if(subJsonBis["TYPE"] == "CULTURE" ){
                    print(subJsonBis)
                }
            }
            
        }
        
        drawMarkers()
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
    
    
    func doResetMap(){
        centerMapOnLocation(location: userLocation.coordinate)
        
        //We go back to the first view
        tabBarController?.selectedIndex = 0
    }
    
    //Set the center of the map on the passed location
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func drawMarkers(){
        for (key,subJson):(String, JSON) in json {
            
            for(keyBis, subJsonBis):(String, JSON) in subJson{
                
                //print(subJsonBis["TYPE"])
                
                if(subJsonBis["TYPE"] == "CULTURE" ){
                    
                    let latitude = subJsonBis["geometry"]["coordinates"][1].double
                    let longitude = subJsonBis["geometry"]["coordinates"][0].double
                    
                    let destinationLocation = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                    
                    let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
                    
                    //let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                    
                    let monumentName = subJsonBis["NOM"].string
                    
                    let destinationAnnotation = MKPointAnnotation()
                    destinationAnnotation.title = monumentName

                    if let location = destinationPlacemark.location {
                        destinationAnnotation.coordinate = location.coordinate
                    }
                    
                    self.map.showAnnotations([destinationAnnotation], animated: false )
                }
            }
            
        }
    }

}
