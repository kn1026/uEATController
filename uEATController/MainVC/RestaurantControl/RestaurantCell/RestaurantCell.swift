//
//  RestaurantCell.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/7/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class RestaurantCell: UITableViewCell {
    
    @IBOutlet var icon: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var address: UILabel!

    var info: RestaurantModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(_ Information: RestaurantModel) {
        self.info = Information
        
        
        
        name.text = self.info.Restaurant_name
        address.text = self.info.Restaurant_address
        
        
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
