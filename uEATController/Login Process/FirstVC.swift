//
//  ViewController.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/3/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
// moveToSignInVC

import UIKit
import Firebase

class FirstVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToLoginVC", sender: self)
        
    }
    
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        
    }
}

