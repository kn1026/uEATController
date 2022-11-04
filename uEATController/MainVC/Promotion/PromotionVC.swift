//
//  PromotionVC.swift
//  uEATController
//
//  Created by Khoi Nguyen on 8/4/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import Firebase
import MGSwipeTableCell

class PromotionVC: UIViewController,  UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate {

    @IBOutlet weak var resBtn: UIButton!
    @IBOutlet weak var OwnerBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var promoArr = [PromotionModel]()
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        resBtn.backgroundColor = UIColor.yellow
        resBtn.setTitleColor(UIColor.black, for: .normal)
        OwnerBtn.backgroundColor = UIColor.clear
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        type = "Restaurant"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        promoArr.removeAll()
        self.loadVoucher(type_created: type)
        
    }
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
    
        if promoArr.isEmpty != true {
            
            tableView.restore()
            return 1
        } else {
            
            tableView.setEmptyMessage("Don't have any voucher, let's create one !!!")
            return 1
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
         return promoArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let item = promoArr[indexPath.row]

        if let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionCell") as? PromotionCell {
            
          
            
            if item.status != "Online" {
               cell.contentView.backgroundColor = UIColor.placeholderText
                
            } else {
            cell.contentView.backgroundColor = UIColor.clear
                
            }
            
            cell.delegate = self
            cell.configureCell(item)
            return cell
                       
                       
        } else {
                       
            return PromotionCell()
                       
        }

    
        
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return ""
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90.0
        
    }
    
    
    func loadVoucher(type_created: String) {
        
        
        
        DataService.instance.mainFireStoreRef.collection("Voucher").whereField("Created by", isEqualTo: type_created).order(by: "timeStamp", descending: true).getDocuments { (snap, err) in
        
        if err != nil {
            
            self.showErrorAlert("Opss !", msg: err!.localizedDescription)
            return
            
        }
            self.promoArr.removeAll()
        
        for item in snap!.documents {
            
            let dict = PromotionModel(postKey: item.documentID, Voucher_model: item.data())
            
            if self.checkDuplicate(item: dict) == false {
            
                self.promoArr.append(dict)
            
            } else {
                
                print("Found duplication")
            
        
            
            }
            
            }
            
            self.tableView.reloadData()
            
        }
        
        
    }
        
        func checkDuplicate(item: PromotionModel) -> Bool {

            
            for i in promoArr {
                
                if i.category == item.category, i.category_url == item.category_url, i.description == item.description, i.title == item.title, i.type == item.type {
                    
                    return true
                    
                }
                
            }
            
            
            return false
            
        }

    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func swiftLoader() {
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 170
        
        config.backgroundColor = UIColor.clear
        config.spinnerColor = UIColor.white
        config.titleTextColor = UIColor.white
        
        
        config.spinnerLineWidth = 3.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.7
        
        
        SwiftLoader.setConfig(config: config)
        
        
        SwiftLoader.show(title: "", animated: true)
        
        
    }
    
    @IBAction func RestaurantBtnPressed(_ sender: Any) {
        
        resBtn.backgroundColor = UIColor.yellow
        OwnerBtn.backgroundColor = UIColor.clear
        
        resBtn.setTitleColor(UIColor.black, for: .normal)
        OwnerBtn.setTitleColor(UIColor.white, for: .normal)
        type = "Restaurant"
        self.loadVoucher(type_created: type)
        
       
        
    }
    
    
    @IBAction func OwnerBtnPressed(_ sender: Any) {
        
        resBtn.backgroundColor = UIColor.clear
        OwnerBtn.backgroundColor = UIColor.yellow
        
        resBtn.setTitleColor(UIColor.white, for: .normal)
        OwnerBtn.setTitleColor(UIColor.black, for: .normal)
        
        type = "Owner"
        self.loadVoucher(type_created: type)
    }
    
    
    @IBAction func createVoucherBtnPressed(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "MoveToCreatePromoVC", sender: nil)
        
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection) -> Bool {
           return true;
       }
       
       // Fetch object from the cache
       
       func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
           
           
           let color = UIColor(red: 249/255, green: 252/255, blue: 254/255, alpha: 1.0)
           
           swipeSettings.transition = MGSwipeTransition.border;
           expansionSettings.buttonIndex = 0
           let padding = 25
           if direction == MGSwipeDirection.rightToLeft {
               expansionSettings.fillOnTrigger = false;
               expansionSettings.threshold = 1.1
               

               let RemoveResize = resizeImage(image: UIImage(named: "remove")!, targetSize: CGSize(width: 25.0, height: 25.0))
               let availableResize = resizeImage(image: UIImage(named: "Security")!, targetSize: CGSize(width: 25.0, height: 25.0))
                 
               let remove = MGSwipeButton(title: "", icon: RemoveResize, backgroundColor: color, padding: padding,  callback: { (cell) -> Bool in
                
                    
                    let sheet = UIAlertController(title: "Are you sure to remove this item", message: "", preferredStyle: .actionSheet)
                    
                    
                    
                    let delete = UIAlertAction(title: "Delete", style: .default) { (alert) in
                        
                        self.deleteAtIndexPath(self.tableView.indexPath(for: cell)!)
                        
                    }
                    
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
                        
                    }
                    

                    sheet.addAction(delete)
                    sheet.addAction(cancel)
                    self.present(sheet, animated: true, completion: nil)

                    
                   
                   return false; //don't autohide to improve delete animation
                   
                   
               });
            

            
              
            let available = MGSwipeButton(title: "", icon: availableResize, backgroundColor: color, padding: padding,  callback: { (cell) -> Bool in
             
                
                self.availableAt(self.tableView.indexPath(for: cell)!)
                
                
                
                return false; //don't autohide to improve delete animation
                
                
            });
            
             

               return [remove, available]
            
           } else {
               
               return nil
            
           }
              
           
    }
    
    func deleteAtIndexPath(_ path: IndexPath) {
     
        swiftLoader()
        
        let item = promoArr[(path as NSIndexPath).row]
       
        DataService.instance.mainFireStoreRef.collection("Voucher").whereField("Created by", isEqualTo: item.Created_by!).whereField("title", isEqualTo: item.title as Any).whereField("description", isEqualTo: item.description as Any).whereField("category", isEqualTo: item.category as Any).getDocuments { (snap, err) in
        
                if err != nil {
                    
                    SwiftLoader.hide()
                    self.showErrorAlert("Opss !", msg: err!.localizedDescription)
                    return
                    
                }
                

                for item in snap!.documents {
                    
                    let id = item.documentID
                    DataService.instance.mainFireStoreRef.collection("Voucher").document(id).delete()
                    
                    self.promoArr.remove(at: (path as NSIndexPath).row)
                    self.tableView.deleteRows(at: [path], with: .left)

                    SwiftLoader.hide()
                    
                    
            }
            
            self.tableView.reloadData()
            
        }
        
    }
    
    
    func availableAt(_ path: IndexPath) {
        
        swiftLoader()
        
        let item = promoArr[(path as NSIndexPath).row]
        
        var update = ""
        
        var i: PromotionModel!
        
        if item.status != "Online" || item.status == "" {
            
            update = "Online"
            let dict = ["title": item.title!, "description": item.description!, "category": item.category!, "type": item.type!, "value": item.value!, "restaurant_id": item.restaurant_id!, "timeStamp": FieldValue.serverTimestamp(), "status": "Online", "category_url": item.category_url!, "fromDate": item.fromDate!, "untilDate": item.untilDate!, "Created by": item.Created_by!] as [String : Any]
            i = PromotionModel(postKey: "Updated", Voucher_model: dict)
            
           
            
            
        } else {
            
            update = "Offline"

            let dict = ["title": item.title!, "description": item.description!, "category": item.category!, "type": item.type!, "value": item.value!, "restaurant_id": item.restaurant_id!, "timeStamp": FieldValue.serverTimestamp(), "status": "Offline", "category_url": item.category_url!, "fromDate": item.fromDate!, "untilDate": item.untilDate!, "Created by": item.Created_by!] as [String : Any]
            

            i = PromotionModel(postKey: "Updated", Voucher_model: dict)
            
           
        }
        
        self.promoArr.remove(at: (path as NSIndexPath).row)
        self.promoArr.insert(i, at: (path as NSIndexPath).row)

        
        DataService.instance.mainFireStoreRef.collection("Voucher").whereField("Created by", isEqualTo: item.Created_by!).whereField("title", isEqualTo: item.title as Any).whereField("description", isEqualTo: item.description as Any).whereField("category", isEqualTo: item.category as Any).getDocuments { (snap, err) in
        
                if err != nil {
                    
                    SwiftLoader.hide()
                    self.showErrorAlert("Opss !", msg: err!.localizedDescription)
                    return
                    
                }
                

                for item in snap!.documents {
                    
                    let id = item.documentID
                    DataService.instance.mainFireStoreRef.collection("Voucher").document(id).updateData(["status": update])

                    SwiftLoader.hide()
                    
                    
            }
            
            self.tableView.reloadData()
            
        }
        
        
        
        
    }
    

}
