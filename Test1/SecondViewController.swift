//
//  SecondViewController.swift
//  Test1
//
//  Created by anthony loroscio on 22/12/2016.
//  Copyright © 2016 anthony loroscio. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    
    var svc: FirstViewController?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let barViewControllers = self.tabBarController?.viewControllers
        svc = barViewControllers![0] as? FirstViewController
        
        //detect when player want to go to the next step
        nextButton.addTarget(self, action: #selector(SecondViewController.goNextStep), for: .touchUpInside)
    }
    

    func goNextStep(){
        svc?.goNextStep();
    }


}

