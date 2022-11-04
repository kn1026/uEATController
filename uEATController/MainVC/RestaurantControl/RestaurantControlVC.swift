//
//  RestaurantControlVC.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/6/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//  RestaurantCell

import UIKit
import Firebase

class RestaurantControlVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var PendingBtn: UIButton!
    @IBOutlet weak var ApprovedBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    private var pullControl = UIRefreshControl()
    
    
    var restaurantArr = [RestaurantModel]()
    var transItem: RestaurantModel!
    var type = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        PendingBtn.backgroundColor = UIColor.yellow
        PendingBtn.setTitleColor(UIColor.black, for: .normal)
        ApprovedBtn.backgroundColor = UIColor.clear
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        
        
        pullControl.tintColor = UIColor.white
        pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = pullControl
        } else {
            tableView.addSubview(pullControl)
        }
        
        type = "Pending"
        loadRestaurant()
        
    }
    
    @objc private func refreshListData(_ sender: Any) {
       // self.pullControl.endRefreshing() // You can stop after API Call
        // Call API
        
        
        loadRestaurant()
        
        
        
    }
    
    
    func loadRestaurant() {
        if type != "" {
            
            
            
            DataService.instance.mainFireStoreRef.collection("Restaurant").whereField("Status", isEqualTo: type).getDocuments { (snapCheck, err) in
            
                if err != nil {
            
                
                    self.showErrorAlert("Opss !", msg: err!.localizedDescription)
                
                    return
            
                }
                
                
                if snapCheck?.isEmpty == true {
                    
                    self.restaurantArr.removeAll()
                    self.tableView.reloadData()
                    
                    return
                    
                } else {
                    
                    self.restaurantArr.removeAll()
                    
                    for item in snapCheck!.documents {
                    
                    
                            let dict = RestaurantModel(postKey: item.documentID, Restaurant_model: item.data())
                            
                            self.restaurantArr.append(dict)
                            
                            self.tableView.reloadData()
                            
                            
                            if self.pullControl.isRefreshing == true {
                                self.pullControl.endRefreshing()
                            }

                        
                    }
                    
                    
                    
                    
                    
                    
                }
                
                
                
                
            }
            
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        if restaurantArr.isEmpty != true {
            
            tableView.restore()
            return 1
        
        } else {
        
            tableView.setEmptyMessage("Loading restaurants !!!")
            return 1
        
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return restaurantArr.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let item = restaurantArr[indexPath.row]
                      
                      
           if let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as? RestaurantCell {
              
               //cell.img.frame = cell.frame.offsetBy(dx: 10, dy: 10);
               if indexPath.row != 0 {
                   let color = self.view.backgroundColor
                   let lineFrame = CGRect(x:0, y:-20, width: self.view.frame.width, height: 40)
                   let line = UIView(frame: lineFrame)
                   line.backgroundColor = color
                   cell.addSubview(line)
                   
               }
               
               cell.configureCell(item)

               return cell
                          
           } else {
                          
               return RestaurantCell()
                          
           }
           
       }
       
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           
           return 200.0
           
       }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = restaurantArr[indexPath.row]
        
        transItem = item
        
        self.performSegue(withIdentifier: "moveToResDetail", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "moveToResDetail"{
            if let destination = segue.destination as? RestaurantDetail {
                
                destination.transItem = transItem
                
                
            }
        }
        
        
    }
    

    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
                                                                                                                                           
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
                                                                                       
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func PendingBtnPressed(_ sender: Any) {
        
        PendingBtn.backgroundColor = UIColor.yellow
        ApprovedBtn.backgroundColor = UIColor.clear
        
        PendingBtn.setTitleColor(UIColor.black, for: .normal)
        ApprovedBtn.setTitleColor(UIColor.white, for: .normal)
        
        
        
        type = "Pending"
        loadRestaurant()
        
    }
    
    @IBAction func ApprovedBtnPressed(_ sender: Any) {
        
        PendingBtn.backgroundColor = UIColor.clear
        ApprovedBtn.backgroundColor = UIColor.yellow
        
        
        PendingBtn.setTitleColor(UIColor.white, for: .normal)
        ApprovedBtn.setTitleColor(UIColor.black, for: .normal)
        
        
        type = "Ready"
        loadRestaurant()
        
    }
    

}
