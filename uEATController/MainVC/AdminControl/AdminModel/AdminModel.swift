//
//  AdminModel.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/17/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation


class AdminModel {


    fileprivate var _Email: String!
    fileprivate var _Status: Bool!

    
    var Email: String! {
        get {
            if _Email == nil {
                _Email = ""
            }
            return _Email
        }
        
    }
    
    var Status: Bool! {
        get {
            if _Status == nil {
                _Status = false
            }
            return _Status
        }
        
    }

    init(postKey: String, Admin_model: Dictionary<String, Any>) {
        
        if let Email = Admin_model["Email"] as? String {
            self._Email = Email
            
        }
        
        if let Status = Admin_model["Status"] as? Bool {
            self._Status = Status
            
        }
        
           
    }







}
