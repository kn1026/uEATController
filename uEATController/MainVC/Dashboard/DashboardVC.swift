//
//  DashboardVC.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/3/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import Firebase

class DashboardVC: UIViewController {

    @IBOutlet weak var totalOrderLbl: UILabel!
    @IBOutlet weak var totalUserLbl: UILabel!
    @IBOutlet weak var activeRestaurantLbl: UILabel!
    @IBOutlet weak var InactiveRestaurantLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard (Auth.auth().currentUser?.uid) != nil else {return}
        
        setupFCMToken()
        
        
    }
    
    
    func setupFCMToken() {
         
         
         guard let fcmToken = Messaging.messaging().fcmToken else { return }
         
         DataService.instance.fcmTokenUserRef.child("Admin").child(fcmToken).observeSingleEvent(of: .value, with: { (snapInfo) in
         
         
             if snapInfo.exists() {
                 
                 
                print("Found")
                
                 
             } else {
                 
                 print("Not found")
                 let profile = [fcmToken: 0 as AnyObject]
                 DataService.instance.fcmTokenUserRef.child("Admin").updateChildValues(profile)
                 
                 
             }
    
                 
         
             
         })
         
       
         
         
     }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard (Auth.auth().currentUser?.uid) != nil else {return}
        
        loadTotalOrderLbl()
        loadTotalUserLbl()
        loadActiveRestaurantLbl()
        loadIInactiveRestaurantLbl()
        
        
    }
    @IBAction func CampusBtn(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToCampusVC", sender: nil)
        
    }
    
    func loadTotalOrderLbl() {
        
        DataService.instance.mainFireStoreRef.collection("Processing_orders").getDocuments { (snaps, err) in
        
        if err != nil {

            self.showErrorAlert("Opss !", msg: err!.localizedDescription)
            return
            
        }
              
           if snaps?.isEmpty == true {
               
               
            self.totalOrderLbl.text = "0"
               
            return
            
           }
        
            self.totalOrderLbl.text = "\(snaps!.count)"
               
        }
        
    }
    
    func loadTotalUserLbl() {
        
        DataService.instance.mainFireStoreRef.collection("Users").getDocuments { (snaps, err) in
        
        if err != nil {

            self.showErrorAlert("Opss !", msg: err!.localizedDescription)
            return
            
        }
              
           if snaps?.isEmpty == true {
               
               
            self.totalUserLbl.text = "0"
               
            return
            
           }
        
            self.totalUserLbl.text = "\(snaps!.count)"
               
        }
        
    }
    
    func loadActiveRestaurantLbl() {
        
        DataService.instance.mainFireStoreRef.collection("Restaurant").whereField("Open", isEqualTo: true).getDocuments { (snaps, err) in
        
        if err != nil {

            self.showErrorAlert("Opss !", msg: err!.localizedDescription)
            return
            
        }
              
           if snaps?.isEmpty == true {
               
               
            self.activeRestaurantLbl.text = "0"
               
            return
            
           }
        
            self.activeRestaurantLbl.text = "\(snaps!.count)"
               
        }
        
    }
    
    func loadIInactiveRestaurantLbl() {
        
        DataService.instance.mainFireStoreRef.collection("Restaurant").whereField("Open", isEqualTo: false).getDocuments { (snaps, err) in
        
        if err != nil {

            self.showErrorAlert("Opss !", msg: err!.localizedDescription)
            return
            
        }
              
           if snaps?.isEmpty == true {
               
               
            self.InactiveRestaurantLbl.text = "0"
               
            return
            
           }
        
            self.InactiveRestaurantLbl.text = "\(snaps!.count)"
               
        }
        
    }
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
                                                                
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
                                                                                       
        present(alert, animated: true, completion: nil)
        
    }
    
    func swiftLoader() {
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 170
        
        config.backgroundColor = UIColor.clear
        config.spinnerColor = UIColor.white
        config.titleTextColor = UIColor.white
        
        
        config.spinnerLineWidth = 3.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.7
        
        
        SwiftLoader.setConfig(config: config)
        
        
        SwiftLoader.show(title: "", animated: true)
        
                                                                    
    }
    
    
    @IBAction func LoadInactiveRestaurantalert(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToPushNotiInActiveVC", sender: nil)
              
    }
    
    
    @IBAction func LoadUsers(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToUsersVC", sender: nil)
        
    }
    

    @IBAction func PromotionBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "moveToPromotionVC", sender: nil)
        
    }
    
}
