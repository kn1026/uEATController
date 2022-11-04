//
//  RestaurantModel.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/7/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation
import CoreLocation


class RestaurantModel {
        
    
         fileprivate var _website: String!
         fileprivate var _Restaurant_email: String!
         fileprivate var _Restaurant_address: String!
         fileprivate var _Restaurant_id: String!
         fileprivate var _Restaurant_name: String!
         fileprivate var _Restaurant_url: String!
         fileprivate var _Restaurant_status: String!
         fileprivate var _Restaurant_phone: String!
         fileprivate var _Restaurant_Open_status: Bool!
         fileprivate var _Lat: CLLocationDegrees!
         fileprivate var _Lon: CLLocationDegrees!
    
    
    
        var website: String! {
            get {
                if _website == nil {
                _website = ""
            }
            return _website
            }
        
        }
    
    
        var Restaurant_email: String! {
            get {
                if _Restaurant_email == nil {
                _Restaurant_email = ""
            }
            return _Restaurant_email
            }
        
        }
        
    
        var Lat: CLLocationDegrees! {
            get {
                if _Lat == nil {
                    _Lat = 0
                }
                return _Lat
            }
            
        }
    
    
       var Lon: CLLocationDegrees! {
           get {
               if _Lon == nil {
                   _Lon = 0
               }
               return _Lon
           }
           
       }

         
    
        var Restaurant_phone: String! {
            get {
                if _Restaurant_phone == nil {
                _Restaurant_phone = ""
            }
            return _Restaurant_phone
            }
        
        }
         
        var Restaurant_address: String! {
            get {
                if _Restaurant_address == nil {
                _Restaurant_address = ""
            }
            return _Restaurant_address
            }
        
        }
    
         
         var Restaurant_id: String! {
             get {
                 if _Restaurant_id == nil {
                     _Restaurant_id = ""
                 }
                 return _Restaurant_id
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
       
       var Restaurant_url: String! {
           get {
               if _Restaurant_url == nil {
                   _Restaurant_url = ""
               }
               return _Restaurant_url
           }
           
       }
       
       var Restaurant_status: String! {
           get {
               if _Restaurant_status == nil {
                   _Restaurant_status = ""
               }
               return _Restaurant_status
           }
           
       }
         
       var Restaurant_Open_status: Bool! {
           get {
               if _Restaurant_Open_status == nil {
                   _Restaurant_Open_status = false
               }
               return _Restaurant_Open_status
           }
           
       }
        

         
         init(postKey: String, Restaurant_model: Dictionary<String, Any>) {
             
             
             
             if let Restaurant_id = Restaurant_model["Restaurant_id"] as? String {
                 self._Restaurant_id = Restaurant_id
                 
             }
             
             if let Restaurant_name = Restaurant_model["businessName"] as? String {
                 self._Restaurant_name = Restaurant_name
                 
             }
           
             if let Restaurant_url = Restaurant_model["LogoUrl"] as? String {
                 self._Restaurant_url = Restaurant_url
                 
             }
             
             if let Restaurant_status = Restaurant_model["Status"] as? String {
                 self._Restaurant_status = Restaurant_status
                 
             }
             
             if let Restaurant_Open_status = Restaurant_model["Open"] as? Bool {
                 self._Restaurant_Open_status = Restaurant_Open_status
                 
             }
            
            if let Restaurant_address = Restaurant_model["businessAddress"] as? String {
                self._Restaurant_address = Restaurant_address
                
            }
            
            if let Restaurant_email = Restaurant_model["Email"] as? String {
                self._Restaurant_email = Restaurant_email
                
            }
            
            if let website = Restaurant_model["webAdress"] as? String {
                self._website = website
                
            }
            
            if let Restaurant_phone = Restaurant_model["Phone"] as? String {
                self._Restaurant_phone = Restaurant_phone
                
            }
            
            if let Lat = Restaurant_model["Lat"] as? CLLocationDegrees {
                self._Lat = Lat
                
            }
            
            if let Lon = Restaurant_model["Lon"] as? CLLocationDegrees {
                self._Lon = Lon
                
            }
       
         }
    
    
    
    
    
    
}
