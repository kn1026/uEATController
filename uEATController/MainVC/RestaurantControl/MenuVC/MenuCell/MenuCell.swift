//
//  MenuCell.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/9/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class MenuCell: UITableViewCell {

    @IBOutlet weak var Quanlity: UIStackView!

    @IBOutlet var img: UIImageView!
    @IBOutlet var lock: UIImageView!
    @IBOutlet var lim: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var count: UILabel!
    
    
    
    
    @IBOutlet weak var plusBtnPressed: UIButton!
    @IBOutlet weak var minusBtnPressed: UIButton!
    
    var info: ItemModel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

        
    }
    
 

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(_ Information: ItemModel) {
        self.info = Information
        

        
        self.name.text = info.name
        self.price.text = "$ \(info.price!)"
        
        
        
        if info.img != nil {
            
            img.image = info.img
            
            
        } else {
            
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
        
        if self.info.quanlity == "0" {
            
            DataService.instance.mainFireStoreRef.collection("Menu").whereField("name", isEqualTo:  self.info.name as Any).whereField("description", isEqualTo:  self.info.description as Any).whereField("category", isEqualTo:  self.info.category as Any).getDocuments { (snap, err) in
            
                    if err != nil {
                        
                        return
                        
                    }

                    for item in snap!.documents {
                        
                        if let count = item["count"] {
                            self.count.text = "\(count)"
                        }
                        
                }
                
            }
            
            
        }

        
        
    }
    
    
    
    
    
    

}
