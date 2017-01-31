//
//  SecondViewController.swift
//  Test1
//
//  Created by anthony loroscio on 22/12/2016.
//  Copyright © 2016 anthony loroscio. All rights reserved.
//

import UIKit
import SafariServices
import SwiftyJSON

class SecondViewController: UIViewController, SFSafariViewControllerDelegate {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var showPathButton: UIButton!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var webButton: UIButton!
    @IBOutlet weak var recenterButton: UIButton!
    
    var json:JSON = []
    
    var svc: FirstViewController?;
    //let urlString = "https://www.hackingwithswift.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let barViewControllers = self.tabBarController?.viewControllers
        svc = barViewControllers![0] as? FirstViewController
        
        //detect when player want to go to the next step
        nextButton.addTarget(self, action: #selector(SecondViewController.goNextStep), for: .touchUpInside)
        
        //detect when player want to leave the game
        leaveButton.addTarget(self, action: #selector(SecondViewController.leaveGame), for: .touchUpInside)
        
        //detect when player want to get web info
        webButton.addTarget(self, action: #selector(SecondViewController.displayWebPage), for: .touchUpInside)
        
        //detect when player want to see the path for the location on the map
        showPathButton.addTarget(self, action: #selector(SecondViewController.displayPathOnMap), for: .touchUpInside)
        
        //detect when player want to recenter the map
        recenterButton.addTarget(self, action: #selector(SecondViewController.recenterMap), for: .touchUpInside)
    }
    

    func goNextStep(){
        svc?.goNextStep();
    }
    
    func leaveGame(){
        svc?.backToHomeScreen()
    }
    
    func displayWebPage(){
        
        json = (svc?.getUrl())!
        
        if let url = URL(string: json["info"].string! as String) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
            
            present(vc, animated: true)
        }
    }

    func displayPathOnMap(){
        svc?.drawPath()
    }
    
    func recenterMap(){
        print("do recenter")
        svc?.doResetMap();
    }
}

