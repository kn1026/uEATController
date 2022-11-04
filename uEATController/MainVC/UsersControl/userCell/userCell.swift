//
//  userCell.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/7/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class userCell: UITableViewCell {

    
    @IBOutlet var img: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var create_time: UILabel!
    @IBOutlet var total_order: UILabel!
    
    
    var info: userModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ Information: userModel) {
        self.info = Information
        
        
        
        name.text = self.info.Name
        email.text = self.info.Email
        phone.text = self.info.Phone
        
        
        if let times = info.timeStamp as? Date {
            
            create_time.text = "Created \(timeAgoSinceDate(times, numericDates: true))"
            
        } else {
            
            print("Can't convert \(info.timeStamp!)")
            
        }
        
        
        DataService.instance.mainFireStoreRef.collection("Processing_orders").whereField("userUID", isEqualTo: info!.user_uid!).getDocuments { (business, err) in
        
        
            if err != nil {
                   
                   print(err!.localizedDescription)
                   return
                   
            }
            

            if business?.isEmpty == true {
         
                let imageAttachment =  NSTextAttachment()
                imageAttachment.image = UIImage(named: "order_popupheader_icn")
                imageAttachment.bounds = CGRect(x: 3, y: -3, width: 25, height: 25)
                let attachmentString = NSAttributedString(attachment: imageAttachment)
                let myString = NSMutableAttributedString(string: "")
                myString.append(attachmentString)
                myString.append(NSMutableAttributedString(string: "  No order yet"))
                self.total_order.attributedText = myString
             
            } else {
     
                let imageAttachment =  NSTextAttachment()
                imageAttachment.image = UIImage(named: "order_popupheader_icn")
                imageAttachment.bounds = CGRect(x: 3, y: -3, width: 25, height: 25)
                let attachmentString = NSAttributedString(attachment: imageAttachment)
                let myString = NSMutableAttributedString(string: "")
                myString.append(attachmentString)
                myString.append(NSMutableAttributedString(string: "  Made \(business!.count) orders"))
    
                self.total_order.attributedText = myString
    
            }
            
            
            
        }
        
        
        if info.url != "" {
            
            
            imageStorage.async.object(forKey: info.url) { result in
                if case .value(let image) = result {
                    
                    DispatchQueue.main.async { // Make sure you're on the main thread here
                        
                        
                        self.img.image = image
                        
                        //try? imageStorage.setObject(image, forKey: url)
                        
                    }
                    
                } else {
                    
                    
                    AF.request(self.info.url).responseImage { response in
                        
                        
                        switch response.result {
                        case let .success(value):
                            self.img.image = value
                            try? imageStorage.setObject(value, forKey: self.info.url)
                        case let .failure(error):
                            print(error)
                        }
                        
                        
                        
                    }
                    
                }
                
            }
            
            
            
        }
        
        
        
    }
    
    

}
