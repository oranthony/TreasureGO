//
//  TableController.swift
//  Test1
//
//  Created by anthony loroscio on 27/12/2016.
//  Copyright © 2016 anthony loroscio. All rights reserved.
//

import UIKit
import SwiftyJSON

class TableController: UITableViewController {
    
    var TableData:Array< String > = Array < String >()    //Still used ?
    var json:JSON = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title="Select a quest"
        
        let path = Bundle.main.path(forResource: "document", ofType: "json")
        let jsonData : NSData = NSData(contentsOfFile: path!)!
        
        
        json = JSON(data: jsonData as Data) // Note: data: parameter name
        
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return json["list"].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = json["list"][indexPath.row]["name"].string

        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "tableSegue"){
            //prepare for segue to the details view controller
            
            
            let tabCtrl       = segue.destination as! UITabBarController
            let destinationVC = tabCtrl.viewControllers![0] as! FirstViewController // Assuming home view controller is in the first tab, else update the array index
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                destinationVC.segueInfo = selectedRow;
            }
            
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //print(indexPath.row)
        
        let destinationVC = FirstViewController()
        destinationVC.segueInfo = indexPath.row
        
        super.performSegue( withIdentifier: "tableSegue", sender: self)
    }


}
