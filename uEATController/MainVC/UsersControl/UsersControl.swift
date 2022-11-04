//
//  UsersControl.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/7/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit

class UsersControl: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var userArr = [userModel]()
    var transItem: userModel!

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
        
        loadUser()
        
    }
    
    @objc private func refreshListData(_ sender: Any) {
       // self.pullControl.endRefreshing() // You can stop after API Call
        // Call API
        
        //self.getRestaurant_ID(email: (Auth.auth().currentUser?.email)!)
        loadUser()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        if userArr.isEmpty != true {
            
            tableView.restore()
            return 1
            
        } else {
            
            tableView.setEmptyMessage("Loading users !!!")
            return 1
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = userArr[indexPath.row]
                   
                   
        if let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? userCell {
           
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
                       
            return userCell()
                       
        }
        
    }
    
    func loadUser() {
        
        
        DataService.instance.mainFireStoreRef.collection("Users").order(by: "timeStamp", descending: true).limit(to: 50).getDocuments { (snaps, err) in
        
            if err != nil {
            
                self.showErrorAlert("Opss !", msg: err!.localizedDescription)
                return
            
            }
            
            if snaps?.isEmpty == true {
                self.userArr.removeAll()
                self.tableView.reloadData()
                return
                
            } else {
                
                
                self.userArr.removeAll()
                for item in snaps!.documents {
                
                
                    let dict = userModel(postKey: item.documentID, User_model: item.data())
                        
                        self.userArr.append(dict)
                        
                }
                
                self.tableView.reloadData()
                if self.pullControl.isRefreshing == true {
                    self.pullControl.endRefreshing()
                }
                
                
                
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 163.0
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = userArr[indexPath.row]
        
        transItem = item
        
        self.performSegue(withIdentifier: "moveToUserDetailVC", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "moveToUserDetailVC"{
            if let destination = segue.destination as? UserDetail {
                
                destination.transItem = transItem
                
                
            }
        }
        
        
    }
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
