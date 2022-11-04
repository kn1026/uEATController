//
//  SupportVC.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/20/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import Firebase
import SCLAlertView
import Alamofire

class SupportVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate {

    @IBOutlet weak var userBtn: UIButton!
    @IBOutlet weak var restaurantBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var pullControl = UIRefreshControl()
    
    var type = ""
    var issue_id = ""
    var uid = ""
    
    var messageArr = [SupportModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userBtn.backgroundColor = UIColor.yellow
        restaurantBtn.backgroundColor = UIColor.clear
                   
        userBtn.setTitleColor(UIColor.black, for: .normal)
        restaurantBtn.setTitleColor(UIColor.white, for: .normal)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        type = "User"
        
        loadMessage(type: "User")
        
        
        pullControl.tintColor = UIColor.white
        pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = pullControl
        } else {
            tableView.addSubview(pullControl)
        }
        
        
    }
    
    @objc private func refreshListData(_ sender: Any) {
       // self.pullControl.endRefreshing() // You can stop after API Call
        // Call API
        
        loadMessage(type: self.type)
        
    }
    

    @IBAction func userBtnPressed(_ sender: Any) {
        
        userBtn.backgroundColor = UIColor.yellow
        restaurantBtn.backgroundColor = UIColor.clear
                   
        userBtn.setTitleColor(UIColor.black, for: .normal)
        restaurantBtn.setTitleColor(UIColor.white, for: .normal)
        
        type = "User"
        
        loadMessage(type: "User")
        
    }
    
    @IBAction func restaurantBtnPressed(_ sender: Any) {
        
        userBtn.backgroundColor = UIColor.clear
        restaurantBtn.backgroundColor = UIColor.yellow
                   
        userBtn.setTitleColor(UIColor.white, for: .normal)
        restaurantBtn.setTitleColor(UIColor.black, for: .normal)
        
        type = "Restaurant"
        
        loadMessage(type: "Restaurant")
    }
    
    
    func loadMessage(type: String) {
        
        DataService.instance.mainFireStoreRef.collection("Issues").whereField("Type", isEqualTo: type).whereField("Status", isEqualTo: true).order(by: "timestamp", descending: true).limit(to: 20).getDocuments { (snap, err) in
        
        if err != nil {
            
            self.showErrorAlert("Opss !", msg: err!.localizedDescription)
            return
            
        }
            
            if snap?.isEmpty == true {
                
                self.messageArr.removeAll()
                self.tableView.reloadData()
                return
                
            } else {
                
                self.messageArr.removeAll()
                for item in snap!.documents {

                    let message = SupportModel(postKey: item.documentID, Issue_model: item.data())
                    self.messageArr.append(message)

                    
                }
                
                if self.pullControl.isRefreshing == true {
                    self.pullControl.endRefreshing()
                }
                                      
                self.tableView.reloadData()
                
            }
        
            
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        if messageArr.isEmpty != true {
            
            tableView.restore()
            return 1
            
        } else {
            
            tableView.setEmptyMessage("Loading issues !!!")
            return 1
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = messageArr[indexPath.row]
                   
                   
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SupportCell") as? SupportCell {
           
            //cell.img.frame = cell.frame.offsetBy(dx: 10, dy: 10);
            if indexPath.row != 0 {
                let color = self.view.backgroundColor
                let lineFrame = CGRect(x:0, y:-20, width: self.view.frame.width, height: 40)
                let line = UIView(frame: lineFrame)
                line.backgroundColor = color
                cell.addSubview(line)
                
            }
            
            cell.delegate = self
            
            cell.configureCell(item)

            return cell
                       
        } else {
                       
            return SupportCell()
                       
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let item = messageArr[indexPath.row]
        
        if item.Status == true {
            
            issue_id = item.Issue_id
            uid = item.ID
            self.performSegue(withIdentifier: "MoveToMessageDetailVC", sender: nil)
            
        } else {
            
            self.showErrorAlert("Oops !!!", msg: "This case is closed")
            
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 170.0
        
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection) -> Bool {
        return true;
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
              
              
        //let color = UIColor(red: 249/255, green: 252/255, blue: 254/255, alpha: 1.0)
              
              swipeSettings.transition = MGSwipeTransition.border;
              expansionSettings.buttonIndex = 0
              let padding = 70
        
        
        
              if direction == MGSwipeDirection.rightToLeft {
                  expansionSettings.fillOnTrigger = false;
                  expansionSettings.threshold = 1.1
                
                    
                let Close = MGSwipeButton(title: "Close case", icon: nil, backgroundColor: UIColor.darkGray, padding: padding,  callback: { (cell) -> Bool in
                   
                      self.closeAtIndexPath(self.tableView.indexPath(for: cell)!)
                      
                      return false; //don't autohide to improve delete animation
                      
                      
                  });
                  
                  
                  return [Close]
               
              } else {
                  
                  return nil
               
              }
                 
              
          }
    
     func closeAtIndexPath(_ path: IndexPath) {
        
        let item = messageArr[path.row]
        
        if item.Status == true {
            
            swiftLoader()
            let id = item.Issue_id
            DataService.instance.mainFireStoreRef.collection("Issues").document(id!).updateData(["Status": false])
            self.loadMessage(type: self.type)
            SwiftLoader.hide()
            
            
        } else {
            
            self.showErrorAlert("Oops !!!", msg: "Case closed.")
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MoveToMessageDetailVC") {
            

            let navigationView = segue.destination as! UINavigationController
            let ChatController = navigationView.topViewController as? SupportMessageDetailVC
            

            ChatController?.chatUID = "Admin"
            ChatController?.chatOrderID = issue_id
            ChatController?.chatKey = issue_id
            ChatController?.userUID = uid

                  
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
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
                                                                                                                                           
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
                                                                                       
        present(alert, animated: true, completion: nil)
        
    }
    
}
