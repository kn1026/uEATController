//
//  CampusVC.swift
//  uEATController
//
//  Created by Khoi Nguyen on 9/7/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import Firebase

class CampusVC: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var campusList = [CampusModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        
        loadCampus()
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
    
        if campusList.isEmpty != true {
            
            tableView.restore()
            return 1
        } else {
            
            tableView.setEmptyMessage("Loading Campus!!!")
            return 1
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
         return campusList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let item = campusList[indexPath.row]

        if let cell = tableView.dequeueReusableCell(withIdentifier: "CampusCell") as? CampusCell {
                 
            cell.CampusMode.tag = indexPath.row
            cell.CampusMode.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            if item.Status == 1 {
                
                cell.CampusMode.setOn(true, animated: true)
            
            } else {
                
                cell.CampusMode.setOn(false, animated: true)
                
            }
            
        
            cell.configureCell(item)
            return cell
                       
                       
        } else {
                       
            return CampusCell()
                       
        }

    
        
        
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        
        let item = campusList[sender.tag]
        
        if item.Status == 1 {
            
            DataService.instance.mainRealTimeDataBaseRef.child("Available_Campus").child(item.School_Name).updateChildValues(["Status": 0])
            campusList[sender.tag]._Status = 0
            
        } else {
            
            DataService.instance.mainRealTimeDataBaseRef.child("Available_Campus").child(item.School_Name).updateChildValues(["Status": 1])
            campusList[sender.tag]._Status = 1
            
        }
        
        
        

          
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return ""
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90.0
        
    }
    
    
    
    func loadCampus() {
        
        DataService.instance.mainRealTimeDataBaseRef.child("Available_Campus").observeSingleEvent(of: .value, with: { (schoolData) in
            
            if schoolData.exists() {
                
                if let snap = schoolData.children.allObjects as? [DataSnapshot] {
                    
                    for item in snap {
                        if let postDict = item.value as? Dictionary<String, Any> {
                            
                            
                            var dict = postDict
                            
                            
                            dict.updateValue(item.key, forKey: "School_Name")
                            
                            let SchoolDataResult = CampusModel(postKey: schoolData.key, School_model: dict)
                            
                            self.campusList.append(SchoolDataResult)
                            
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                    
                
                    
                }
                
                
                
            } else {
                
                SwiftLoader.hide()
                
                self.showErrorAlert("Ops", msg: "Can't get campus data, please check your connection and try again")
                
            }
            
            
            
            
            
        })
        
        
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
    

    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
