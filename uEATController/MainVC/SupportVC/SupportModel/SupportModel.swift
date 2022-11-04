//
//  SupportModel.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/20/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation


class SupportModel {
    
    fileprivate var _Issue_id: String!
    fileprivate var _ID: String!
    fileprivate var _Issue: String!
    fileprivate var _Issue_Type: String!
    fileprivate var _Status: Bool!
    fileprivate var _timestamp: Any!
    
    
    

    var Issue_id: String! {
        get {
            if _Issue_id == nil {
                _Issue_id = ""
            }
            return _Issue_id
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
    
    var Issue: String! {
        get {
            if _Issue == nil {
                _Issue = ""
            }
            return _Issue
        }
        
    }
    
    var Issue_Type: String! {
        get {
            if _Issue_Type == nil {
                _Issue_Type = ""
            }
            return _Issue_Type
        }
        
    }
    
    var ID: String! {
        get {
            if _ID == nil {
                _ID = ""
            }
            return _ID
        }
        
    }
    
    var  timestamp: Any! {
        get {
            if _timestamp == nil {
                _timestamp = 0
            }
            return _timestamp
        }
    }
    
    
    init(postKey: String, Issue_model: Dictionary<String, Any>) {
        
        
        if let Issue_id = Issue_model["Issue_id"] as? String {

            self._Issue_id = Issue_id
            
        }
        
        if let ID = Issue_model["Id"] as? String {

            self._ID = ID
            
        }
        
        if let Issue = Issue_model["Issue"] as? String {

            self._Issue = Issue
            
        }
        
        if let Issue_Type = Issue_model["Type"] as? String {

            self._Issue_Type = Issue_Type
            
        }
        
        
        if let Status = Issue_model["Status"] as? Bool {
            self._Status = Status
            
        }

        
        if let timestamp = Issue_model["timestamp"] {
            self._timestamp = timestamp
            
        }
        
        

    }
    
    
   
    
    
    
    
    
}
