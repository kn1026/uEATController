//
//  MenuVC.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/9/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var section = ["Non-Vegan", "Vegan", "Add-Ons"]
    var menu = [[ItemModel]]()
    var vegan = [ItemModel]()
    var Nonvegan = [ItemModel]()
    var AddOn = [ItemModel]()
    
    var id = ""
    
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if id != "" {
            loadMenu(id: id)
        }
        
        
    }
    
    func loadMenu(id: String) {
         
         
         DataService.instance.mainFireStoreRef.collection("Menu").whereField("restaurant_id", isEqualTo: id).getDocuments { (snap, err) in
             
             if err != nil {
                 
                 self.showErrorAlert("Opss !", msg: err!.localizedDescription)
                 return
                 
             }

             self.vegan.removeAll()
             self.Nonvegan.removeAll()
             self.AddOn.removeAll()
             self.menu.removeAll()
             

             for item in snap!.documents {
   
                 let dict = ItemModel(postKey: item.documentID, Item_model: item.data())
                 

                 if let type = item["type"] as? String {
                     
                     if type == "Vegan" {
                         
                         self.vegan.append(dict)
                         
                     } else if type == "Non-Vegan" {
                         
                         self.Nonvegan.append(dict)
                         
                     } else {
                         
                         self.AddOn.append(dict)
                         
                     }
                 }
                 
    
             }
             self.menu.append(self.Nonvegan)
             self.menu.append(self.vegan)
             
             self.menu.append(self.AddOn)
             
    
             self.tableView.reloadData()
             
    
         }
         
     }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
                                                                                            
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
                                                                                       
        present(alert, animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        if menu.isEmpty != true {
            
            tableView.restore()
            return menu.count
            
        } else {
            
            tableView.setEmptyMessage("Loading menu !!!")
            return menu.count
            
        }
    

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
         return menu[section].count
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let item = menu[indexPath.section][indexPath.row]
                   
                   
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as? MenuCell {
            
            
            if item.status != "Online" {
                
                cell.lock.isHidden = false
                cell.Quanlity.isHidden = true
                
            } else {
                cell.lock.isHidden = true
                
                if item.quanlity == "0" {
                    
                    cell.Quanlity.isHidden = false
                    cell.lim.text = "Limit"
                } else if item.quanlity == "None" {
                    cell.Quanlity.isHidden = true
                     cell.lim.text = "No limit"
                    
                }
            }
             
            
            cell.configureCell(item)

            return cell
                       
        } else {
                       
            return MenuCell()
                       
        }
    
        
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return ""
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 140.0
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 55))
        returnedView.backgroundColor = .clear

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        label.textColor = .white
        label.text = self.section[section]
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        returnedView.addSubview(label)

        return returnedView
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
