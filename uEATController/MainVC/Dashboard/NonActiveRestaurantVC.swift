//
//  NonActiveRestaurantVC.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/3/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import Firebase

class NonActiveRestaurantVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var SelectAllBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var pullControl = UIRefreshControl()
    
    var rowsWhichAreChecked = [NSIndexPath]()
    
    var res_list = [NonActiveRestaurantModel]()
    
    @IBOutlet weak var pushNoti: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        pullControl.tintColor = UIColor.white
        pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = pullControl
        } else {
            tableView.addSubview(pullControl)
        }
        
        
        loadInactiveRestaurant()
    }
    
    @objc private func refreshListData(_ sender: Any) {
       // self.pullControl.endRefreshing() // You can stop after API Call
        // Call API
        
        self.loadInactiveRestaurant()
        
    }
    
    func loadInactiveRestaurant() {
        
        res_list.removeAll()
        
        DataService.instance.mainFireStoreRef.collection("Restaurant").whereField("Open", isEqualTo: false).getDocuments { (snap, err) in
               
               if err != nil {
               
                   
                self.showErrorAlert("Opss !", msg: err!.localizedDescription)
                   return
               
               }
        
               if snap?.isEmpty == true {
                
                print("Empty")
                   
                return
                   
                             
               } else {
                   
                
                    for item in snap!.documents {
                                  
                                  
                        let i = item.data()
                        let noti = NonActiveRestaurantModel(postKey: item.documentID, NonActiveRestaurant: i)
                        self.res_list.append(noti)
                                  
                                  
                        }
                    if self.pullControl.isRefreshing == true {
                                   self.pullControl.endRefreshing()
                               }
                    
                    self.tableView.reloadData()
                   
               }
           }
        
    }
    
    func updateCount() -> Int {
        
        var count = 0
        
        for i in res_list {
            
            if i.check == true {
                count += 1
            }
            
            
        }
        
        return count
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
         
         if res_list.isEmpty != true {
             
             tableView.restore()
             return 1
             
         } else {
             
             tableView.setEmptyMessage("Loading restaurants !!!")
             return 1
             
         }
         
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
          return res_list.count
            
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
         let item = res_list[indexPath.row]

         if let cell = tableView.dequeueReusableCell(withIdentifier: "NonActiveRestaurantCell") as? NonActiveRestaurantCell {
                       
             
             cell.configureCell(item)
            
            if item.check == true {
                cell.backgroundColor = UIColor.yellow
                cell.name.textColor = UIColor.black
            } else {
                cell.backgroundColor = UIColor.clear
                cell.name.textColor = UIColor.white
            }
            
            
            return cell
                                          
         } else {
                        
             return NonActiveRestaurantCell()
                        
         }
    
     }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
            if res_list[indexPath.row].check == true{
                res_list[indexPath.row].check = false
            } else{
                res_list[indexPath.row].check = true
            }

        
        
            let count = updateCount()
            
            pushNoti.setTitle("Send push notification (\(count))", for: .normal)
        
            self.tableView.reloadData()
        
        
    }
    
    
    @IBAction func selectAllBtnPressed(_ sender: Any) {
        
        
        if SelectAllBtn.titleLabel!.text == "Select all" {
            
            for i in res_list {
            
                i.check = true
 
            }
            
            SelectAllBtn.setTitle("Deselect all", for: .normal)
        
            } else {
                
                for i in res_list {
                
                    i.check = false
                
                }
            
             SelectAllBtn.setTitle("Select all", for: .normal)
                
        }
         
        
        
        
        let count = updateCount()
        
        pushNoti.setTitle("Send push notification (\(count))", for: .normal)
        self.tableView.reloadData()
        
    }
    
     
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         
         return ""
         
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         
         return 90.0
         
     }

    @IBAction func back1BtnPressed(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func pushNotification(_ sender: Any) {
        
        let key = getKey()
        
        if key.isEmpty == true {
            self.showErrorAlert("Oops !", msg: "Please select restaurant to send notification")
        } else {
            
            swiftLoader()
            
            for i in key {
                ResOpentNoti(key: i)
            }
            
            
            for i in res_list {
                i.check = false
            }
            
            let count = updateCount()
            pushNoti.setTitle("Send push notification (\(count))", for: .normal)
            
            SwiftLoader.hide()
            self.tableView.reloadData()
            
        }
        
    }
    
    func ResOpentNoti(key: String) {
        
        DataService.instance.mainRealTimeDataBaseRef.child("ResOpentNoti").child(key).child("Open").removeValue()
        let values: Dictionary<String, AnyObject>  = ["Open": 1 as AnyObject]
        DataService.instance.mainRealTimeDataBaseRef.child("ResOpentNoti").child(key).setValue(values)
        
    }
    
    func getKey() -> [String] {
        
        var key = [String]()
        
        for i in res_list {
            
            if i.check == true {
                key.append(i.Restaurant_key)
            }
            
        }
        
        return key
        
    }
    
}
