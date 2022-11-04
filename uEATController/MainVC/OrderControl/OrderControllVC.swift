//
//  OrderControllVC.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/7/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit

class OrderControllVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var AcceptedBtn: UIButton!
    @IBOutlet weak var CompletedBtn: UIButton!
    @IBOutlet weak var cookingBtn: UIButton!
    @IBOutlet weak var PickingUpBtn: UIButton!
    
    
    var type = ""
    var transItem: OrderModel!
    var orderArr = [OrderModel]()
    private var pullControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        AcceptedBtn.backgroundColor = UIColor.yellow
        AcceptedBtn.setTitleColor(UIColor.black, for: .normal)
        CompletedBtn.backgroundColor = UIColor.clear
        cookingBtn.backgroundColor = UIColor.clear
        PickingUpBtn.backgroundColor = UIColor.clear
       
        type = "Processed"
        
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
        
        
        self.loadOrder(status: type)
        
    }
    
    @objc private func refreshListData(_ sender: Any) {
       // self.pullControl.endRefreshing() // You can stop after API Call
        // Call API
        
        loadOrder(status: self.type)
        
    }
    
    
    func loadOrder(status: String) {
        
        DataService.instance.mainFireStoreRef.collection("Processing_orders").order(by: "Order_time", descending: true).whereField("Status", isEqualTo: status).limit(to: 25).getDocuments { (snaps, err) in
         
         if err != nil {
             
            
           
             self.showErrorAlert("Opss !", msg: err!.localizedDescription)
             print(err!.localizedDescription)
             return
             
         }
             
             
            
            if snaps?.isEmpty == true {
                
                
                self.orderArr.removeAll()
                self.tableView.reloadData()
                return
                
            }
         
             self.orderArr.removeAll()
            
             for item in snaps!.documents {
                
                let order = OrderModel(postKey: item.documentID, Order_model: item.data())
                 self.orderArr.append(order)
         
             }
             
            if self.pullControl.isRefreshing == true {
                self.pullControl.endRefreshing()
            }
            
             self.tableView.reloadData()
             
             
             
             
         }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        if orderArr.isEmpty != true {
            
            tableView.restore()
            return 1
            
        } else {
            
            tableView.setEmptyMessage("Loading orders !!!")
            return 1
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = orderArr[indexPath.row]
                   
                   
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as? OrderCell {
           
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
                       
            return OrderCell()
                       
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150.0
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        transItem = orderArr[indexPath.row]
        self.performSegue(withIdentifier:  "moveToOrderDetail", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "moveToOrderDetail"{
            if let destination = segue.destination as? OrderDetailVC {
                
                destination.item = transItem
                
                
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
    
    @IBAction func AcceptedBtnPressed(_ sender: Any) {
         
     
         if self.type != "Accepted" {
             self.type = "Processed"
             
             
             AcceptedBtn.backgroundColor = UIColor.yellow
             PickingUpBtn.backgroundColor = UIColor.clear
             CompletedBtn.backgroundColor = UIColor.clear
             cookingBtn.backgroundColor = UIColor.clear
             
             
            AcceptedBtn.setTitleColor(UIColor.black, for: .normal)
             PickingUpBtn.setTitleColor(UIColor.white, for: .normal)
             CompletedBtn.setTitleColor(UIColor.white, for: .normal)
             cookingBtn.setTitleColor(UIColor.white, for: .normal)
             
            self.loadOrder(status: self.type)
         }
         
         
     }
     
     @IBAction func PickingUpBtnPressed(_ sender: Any) {
         
         if self.type != "Picked up" {
             self.type = "Cooked"
             
             
             AcceptedBtn.backgroundColor = UIColor.clear
             PickingUpBtn.backgroundColor = UIColor.yellow
             CompletedBtn.backgroundColor = UIColor.clear
             cookingBtn.backgroundColor = UIColor.clear
             
             
             AcceptedBtn.setTitleColor(UIColor.white, for: .normal)
             PickingUpBtn.setTitleColor(UIColor.black, for: .normal)
             CompletedBtn.setTitleColor(UIColor.white, for: .normal)
             cookingBtn.setTitleColor(UIColor.white, for: .normal)
             
             self.loadOrder(status: self.type)
             
         }
     }
     
     @IBAction func CompletedBtnPressed(_ sender: Any) {
         
         if self.type != "Completed" {
             self.type = "Completed"
             
             
             AcceptedBtn.backgroundColor = UIColor.clear
             PickingUpBtn.backgroundColor = UIColor.clear
             CompletedBtn.backgroundColor = UIColor.yellow
             cookingBtn.backgroundColor = UIColor.clear
             
             
             AcceptedBtn.setTitleColor(UIColor.white, for: .normal)
             PickingUpBtn.setTitleColor(UIColor.white, for: .normal)
             CompletedBtn.setTitleColor(UIColor.black, for: .normal)
             cookingBtn.setTitleColor(UIColor.white, for: .normal)
             
             
             self.loadOrder(status: self.type)
             
         }
         
         
         
         
         
         
     }
     
     @IBAction func CookingBtnPressed(_ sender: Any) {
         
         if self.type != "Started" {
             self.type = "Started"
            
            
            AcceptedBtn.backgroundColor = UIColor.clear
            PickingUpBtn.backgroundColor = UIColor.clear
            CompletedBtn.backgroundColor = UIColor.clear
            cookingBtn.backgroundColor = UIColor.yellow
            
            
            AcceptedBtn.setTitleColor(UIColor.white, for: .normal)
            PickingUpBtn.setTitleColor(UIColor.white, for: .normal)
            CompletedBtn.setTitleColor(UIColor.white, for: .normal)
            cookingBtn.setTitleColor(UIColor.black, for: .normal)
    

             
             self.loadOrder(status: self.type)
             
         }
         
    
         
         
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
    

    

}
