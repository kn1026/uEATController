//
//  AdminCell.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/17/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit

class AdminCell: UITableViewCell {
    
    
    @IBOutlet var email: UILabel!
    
    var info: AdminModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(_ Information: AdminModel) {
        self.info = Information
        
        
        
        self.email.text = self.info.Email
        
        
        
    }
    
    
    

}
