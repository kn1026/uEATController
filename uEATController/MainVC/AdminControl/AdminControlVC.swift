
//
//  AdminControlVC.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/17/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit

class AdminControlVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var AdminArr = [AdminModel]()
    private var pullControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        pullControl.tintColor = UIColor.white
        pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = pullControl
        } else {
            tableView.addSubview(pullControl)
        }
        
        loadAdminList()
        
    }
    
    @objc private func refreshListData(_ sender: Any) {
       // self.pullControl.endRefreshing() // You can stop after API Call
        // Call API
        
        //self.getRestaurant_ID(email: (Auth.auth().currentUser?.email)!)
        loadAdminList()
        
    }
    
    
    
    func loadAdminList() {
        
        DataService.instance.mainFireStoreRef.collection("Admin-List").getDocuments { (snaps, err) in
        
            if err != nil {
            
                self.showErrorAlert("Opss !", msg: err!.localizedDescription)
                return
            
            }
            
            if snaps?.isEmpty == true {
                self.AdminArr.removeAll()
                self.tableView.reloadData()
                return
                
            } else {
                
                
                self.AdminArr.removeAll()
                for item in snaps!.documents {
                
                
                    let dict = AdminModel(postKey: item.documentID, Admin_model: item.data())
                        
                        self.AdminArr.append(dict)
                        
                }
                
                self.tableView.reloadData()
                if self.pullControl.isRefreshing == true {
                    self.pullControl.endRefreshing()
                }
                
                
                
            }
            
            
        }
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        if AdminArr.isEmpty != true {
            
            tableView.restore()
            return 1
            
        } else {
            
            tableView.setEmptyMessage("Loading admin-list !!!")
            return 1
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AdminArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = AdminArr[indexPath.row]
                   
                   
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AdminCell") as? AdminCell {
           
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
                       
            return AdminCell()
                       
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90.0
        
    }
    
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
                                                                                                                                           
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
                                                                                       
        present(alert, animated: true, completion: nil)
        
    }
    


    @IBAction func addUserBtnPressed(_ sender: Any) {
        
        
        

        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: nil)
        
        
        self.view.endEditing(true)
    }
    
}
