//
//  userModel.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/7/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import Foundation


class userModel {
    
    
    fileprivate var _Birthday: String!
    fileprivate var _Email: String!
    fileprivate var _Name: String!
    fileprivate var _Gender: String!
    fileprivate var _Phone: String!
    fileprivate var _url: String!
    fileprivate var _user_uid: String!
    fileprivate var _campus: String!
    fileprivate var _timeStamp: Any!
    
    
    
    
    
    var Birthday: String! {
        get {
            if _Birthday == nil {
                _Birthday = ""
            }
            return _Birthday
        }
        
    }
    
    var Gender: String! {
        get {
            if _Gender == nil {
                _Gender = ""
            }
            return _Gender
        }
        
    }
    
    var campus: String! {
        get {
            if _campus == nil {
                _campus = ""
            }
            return _campus
        }
        
    }
    
    
    var Name: String! {
        get {
            if _Name == nil {
                _Name = ""
            }
            return _Name
        }
        
    }
    
    var url: String! {
        get {
            if _url == nil {
                _url = ""
            }
            return _url
        }
        
    }
    
    var Email: String! {
        get {
            if _Email == nil {
                _Email = ""
            }
            return _Email
        }
        
    }
    
    var Phone: String! {
        get {
            if _Phone == nil {
                _Phone = ""
            }
            return _Phone
        }
        
    }
    
    var user_uid: String! {
        get {
            if _user_uid == nil {
                _user_uid = ""
            }
            return _user_uid
        }
        
    }
    
    var timeStamp: Any! {
        get {
            if _timeStamp == nil {
                _timeStamp = 0
            }
            return _timeStamp
        }
    }
    

    
    
    
    init(postKey: String, User_model: Dictionary<String, Any>) {
        
        
        if let Name = User_model["Name"] as? String {
            self._Name = Name
            
        }
        
        if let Email = User_model["Email"] as? String {
            self._Email = Email
            
        }
        
        if let Phone = User_model["Phone"] as? String {
            self._Phone = Phone
            
        }
        
        if let url = User_model["avatarUrl"] as? String {
            self._url = url
            
        }
        
        if let user_uid = User_model["userUID"] as? String {
            self._user_uid = user_uid
            
        }
        
        if let timeStamp = User_model["timeStamp"] {
            self._timeStamp = timeStamp
            
        }
        
        
        if let campus = User_model["Campus"] as? String {
            self._campus = campus
            
        }
        
        if let Birthday = User_model["Birthday"] as? String {
            self._Birthday = Birthday
            
        }
        
        if let Gender = User_model["Gender"] as? String {
            self._Gender = Gender
            
        }
    
        
    }
    
    
    
    
}
