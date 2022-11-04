//
//  HomePageVC.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/3/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import Firebase

class HomePageVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        check_condition()
        
    }
    
    // check condition for login
    
    func check_condition() {
        
        
        if let uid = Auth.auth().currentUser?.uid, uid != "" {
        
                 // Fetch object from the cache
                return
                 
             } else {
             
                try! Auth.auth().signOut()
                self.performSegue(withIdentifier: "moveToSignInVC", sender: nil)
         
        }
             
        
        
    }
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    



}
