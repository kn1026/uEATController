//
//  NonActiveRestaurantModel.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/6/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation


class NonActiveRestaurantModel {
    
    fileprivate var _Restaurant_key: String!
    fileprivate var _time_close: Any!
    fileprivate var _Restaurant_name: String!
    fileprivate var _Restaurant_url: String!
    
    var check = false
    
    
    
    var Restaurant_key: String! {
        get {
            if _Restaurant_key == nil {
                _Restaurant_key = ""
            }
            return _Restaurant_key
        }
        
    }
    
    var Restaurant_name: String! {
        get {
            if _Restaurant_name == nil {
                _Restaurant_name = ""
            }
            return _Restaurant_name
        }
        
    }
    
    
    var time_close: Any! {
        get {
            if _time_close == nil {
                _time_close = 0
            }
            return _time_close
        }
    }
    
    var Restaurant_url: String! {
        get {
            if _Restaurant_url == nil {
                _Restaurant_url = ""
            }
            return _Restaurant_url
        }
        
    }
    
    
    
    init(postKey: String, NonActiveRestaurant: Dictionary<String, Any>) {
        
    
        if let Restaurant_key = NonActiveRestaurant["Restaurant_id"] as? String {
            self._Restaurant_key = Restaurant_key
            
        }
        
        if let Restaurant_name = NonActiveRestaurant["businessName"] as? String {
            self._Restaurant_name = Restaurant_name
            
        }
        
        if let time_close = NonActiveRestaurant["Status_time_updated"] {
            
            self._time_close = time_close
            
        }
        
        if let Restaurant_url = NonActiveRestaurant["LogoUrl"] as? String {
            self._Restaurant_url = Restaurant_url
            
        }
        
        
    }
    
    
    
}
