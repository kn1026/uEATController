//
//  PromotionCell.swift
//  uEATController
//
//  Created by Khoi Nguyen on 8/4/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class PromotionCell: MGSwipeTableCell {

    @IBOutlet var name: UILabel!
       @IBOutlet var descriptionLbl: UILabel!
       
       
       var info: PromotionModel!
       override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
       }
       
       func configureCell(_ Information: PromotionModel) {
           self.info = Information
           
        
           name.text = "\(self.info.title!) - \(self.info.description!)"
           
           
           if let FromTimes = info.fromDate as? Date, let UntilTime = info.untilDate as? Date {
               
               descriptionLbl.text = "Active from \(convertDate(date: FromTimes)) to \(convertDate(date: UntilTime))"
               
               
           } else {
               
               descriptionLbl.text = "Error day/time"
               
               
           }
           
           
       }
       
       
       func convertDate(date: Date!) -> String {
           
           let dateFormatter = DateFormatter()
           dateFormatter.locale = Locale(identifier: "en_US")
           dateFormatter.dateStyle = DateFormatter.Style.short
           dateFormatter.timeStyle = DateFormatter.Style.short
           //dateFormatter.dateFormat = "MM-dd-yyyy"
           let result = dateFormatter.string(from: date)

           
           return result
       }
    
    
    

}
