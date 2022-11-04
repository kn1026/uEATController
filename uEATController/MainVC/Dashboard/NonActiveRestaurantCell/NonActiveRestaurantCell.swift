//
//  NonActiveRestaurantCell.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/6/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class NonActiveRestaurantCell: UITableViewCell {
    
    @IBOutlet var icon: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var timeLbl: UILabel!
    
    var info: NonActiveRestaurantModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(_ Information: NonActiveRestaurantModel) {
        self.info = Information
        
        self.name.text = self.info.Restaurant_name
        
        
        if let times = info.time_close as? Date {
            
            timeLbl.text = timeAgoSinceDate(times, numericDates: true)
            
        } else {
            
            print("Can't convert \(info.time_close!)")
            
        }
        
        if info.Restaurant_url != "" {
            
            
            imageStorage.async.object(forKey: info.Restaurant_url) { result in
                if case .value(let image) = result {
                    
                    DispatchQueue.main.async { // Make sure you're on the main thread here
                        
                        
                        self.icon.image = image
                        
                        //try? imageStorage.setObject(image, forKey: url)
                        
                    }
                    
                } else {
                    
                    
                    AF.request(self.info.Restaurant_url).responseImage { response in
                        
                        switch response.result {
                        case let .success(value):
                            self.icon.image = value
                            try? imageStorage.setObject(value, forKey: self.info.Restaurant_url)
                        case let .failure(error):
                            print(error)
                        }
                        
                        
                        
                    }
                    
                }
                
            }
            
            
            
        }
        
        
    }
    
    
    

}
