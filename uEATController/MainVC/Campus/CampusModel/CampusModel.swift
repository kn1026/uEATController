//
//  CampusModel.swift
//  uEATController
//
//  Created by Khoi Nguyen on 9/7/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation


class CampusModel {
    
    
    fileprivate var _School_Name: String!
    fileprivate var _Domain: String!
    var _Status: Int!
    fileprivate var _Url: String!
    
    
    
    var Status: Int! {
        get {
            if _Status == nil {
                _Status = 0
            }
            return _Status
        }
        
    }
    
    var Url: String! {
        get {
            if _Url == nil {
                _Url = ""
            }
            return _Url
        }
        
    }
    
    var Domain: String! {
        get {
            if _Domain == nil {
                _Domain = ""
            }
            return _Domain
        }
        
    }
    
    var School_Name: String! {
        get {
            if _School_Name == nil {
                _School_Name = ""
            }
            return _School_Name
        }
        
    }
    
    

    
    init(postKey: String, School_model: Dictionary<String, Any>) {
        
        
        
        if let School_Name = School_model["School_Name"] as? String {
            self._School_Name = School_Name
            
        }
        
        if let Domain = School_model["Domain"] as? String {
            self._Domain = Domain
            
        }
        
        if let Url = School_model["Url"] as? String {
            self._Url = Url
            
        }
        
        if let Status = School_model["Status"] as? Int {
            self._Status = Status
            
        }
        
        
    }
    
    
}
