//
//  CampusCell.swift
//  uEATController
//
//  Created by Khoi Nguyen on 9/7/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import Cache
import Alamofire
import AlamofireImage

class CampusCell: UITableViewCell {
    
    @IBOutlet weak var uniName: UILabel!
    @IBOutlet weak var campusImg: UIImageView!
    @IBOutlet weak var CampusMode: UISwitch!
    var info: CampusModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ Information: CampusModel) {
        
        self.info = Information
        
        uniName.text = self.info.School_Name
        
        if info.Url != "" {
            
            
            imageStorage.async.object(forKey: info.Url) { result in
                if case .value(let image) = result {
                    
                    DispatchQueue.main.async { // Make sure you're on the main thread here
                        
                        
                        self.campusImg.image = image
                        
                        //try? imageStorage.setObject(image, forKey: url)
                        
                    }
                    
                } else {
                    
                    
                    AF.request(self.info.Url).responseImage { response in
                        
                        switch response.result {
                        case let .success(value):
                            self.campusImg.image = value
                            try? imageStorage.setObject(value, forKey: self.info.Url)
                        case let .failure(error):
                            print(error)
                        }
                        
                        
                        
                    }
                    
                }
                
            }
                
        }
        
        
    }
    
    
    

}
