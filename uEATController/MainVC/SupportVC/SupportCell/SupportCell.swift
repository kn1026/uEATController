//
//  SupportCell.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/20/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MGSwipeTableCell

class SupportCell: MGSwipeTableCell {
    

    @IBOutlet var img: UIImageView!
    @IBOutlet var Name: UILabel!
    @IBOutlet var Issue: UILabel!
    @IBOutlet var timeStamp: UILabel!
    @IBOutlet var Status: UILabel!
    
    var info: SupportModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ Information: SupportModel) {
        self.info = Information
        
        
        if let times = info.timestamp as? Date {
            
            timeStamp.text = timeAgoSinceDate(times, numericDates: true)
            
        } else {
            
            print("Can't convert \(info.timestamp!)")
            
        }
        
        self.Issue.text = "Issue: \(self.info.Issue!)"
        
        if self.info.Status == false {
            
            self.Status.text = "Status: Sovled"
            
        } else {
            
            self.Status.text = "Status: Solving"
            
        }
        
        
        if self.info.Issue_Type == "User" {
            
            DataService.instance.mainFireStoreRef.collection("Users").whereField("userUID", isEqualTo: info.ID!).getDocuments { (business, err) in
            
            
                if err != nil {
                       
                       print(err!.localizedDescription)
                       return
                       
                }
                

                for item in business!.documents {
                    
                    if let user_name = item["Name"] as? String {
                        
                        self.Name.text = user_name
                    
                        
                    }
                    
                    if let LogoUrl = item["avatarUrl"] as? String {
                        
                        imageStorage.async.object(forKey: LogoUrl) { result in
                            if case .value(let image) = result {
                                
                                DispatchQueue.main.async { // Make sure you're on the main thread here
                                    
                                    
                                    self.img.image = image
                                    
                                    
                                }
                                
                            } else {
                                
                                
                                AF.request(LogoUrl).responseImage { response in
                                    
                                    switch response.result {
                                    case let .success(value):
                                        self.img.image = value
                                        try? imageStorage.setObject(value, forKey: LogoUrl)
                                    case let .failure(error):
                                        print(error)
                                    }
                                    
                                    
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                    } else {
                        
                        
                        
                    }
                    
                    
                    
                }
                
                
                
            }
            
        } else if self.info.Issue_Type == "Restaurant" {
            
            
            
            DataService.instance.mainFireStoreRef.collection("Restaurant").whereField("Restaurant_id", isEqualTo: info.ID!).getDocuments { (business, err) in
            
            
                if err != nil {
                       
                       print(err!.localizedDescription)
                       return
                       
                }
                

                for item in business!.documents {
                    
                    if let user_name = item["businessName"] as? String {
                        
                        self.Name.text = user_name
                    
                        
                    }
                    
                    if let LogoUrl = item["LogoUrl"] as? String {
                        
                        imageStorage.async.object(forKey: LogoUrl) { result in
                            if case .value(let image) = result {
                                
                                DispatchQueue.main.async { // Make sure you're on the main thread here
                                    
                                    
                                    self.img.image = image
                                    
                                    
                                }
                                
                            } else {
                                
                                
                                AF.request(LogoUrl).responseImage { response in
                                    
                                    switch response.result {
                                    case let .success(value):
                                        self.img.image = value
                                        try? imageStorage.setObject(value, forKey: LogoUrl)
                                    case let .failure(error):
                                        print(error)
                                    }
                                    
                                    
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                    } else {
                        
                        
                        
                    }
                    
                    
                    
                }
                
                
                
            }
            
            
            
            
            
        }
        

        
    }
    
    
    
    
    

}
