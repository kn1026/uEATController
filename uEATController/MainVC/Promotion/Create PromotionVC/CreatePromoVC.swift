//
//  CreatePromoVC.swift
//  uEATController
//
//  Created by Khoi Nguyen on 8/5/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import Firebase

class CreatePromoVC: UIViewController, UITextFieldDelegate {
    
    
    enum pickView {
        
        case type
        case category
     
    }
    
    var pickerViewController = pickView.type

    @IBOutlet weak var validLimitTxtField: UITextField!
    @IBOutlet weak var validUntilTxtField: UITextField!
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var DescriptionTxrField: UITextField!
    @IBOutlet weak var TypeTxtField: UITextField!
    @IBOutlet weak var ValueTxtField: UITextField!
    @IBOutlet weak var categoryTxtField: UITextField!
    @IBOutlet weak var numberOfUseTxtField: UITextField!
    
    
    var category = ["All", "First user", "Every 10th order"]
    var type = ["$", "%"]
    var restaurant_id = ""
    var fromDate: Date!
    var untilDate: Date!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleTxtField.attributedPlaceholder = NSAttributedString(string: "Title",
                                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                      
        titleTxtField.delegate = self
               
        DescriptionTxrField.attributedPlaceholder = NSAttributedString(string: "Description",
                                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                      
        DescriptionTxrField.delegate = self

        categoryTxtField.attributedPlaceholder = NSAttributedString(string: "Category",
                                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                      
        categoryTxtField.delegate = self
        
        TypeTxtField.attributedPlaceholder = NSAttributedString(string: "Type",
                                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                      
        TypeTxtField.delegate = self
        
        ValueTxtField.attributedPlaceholder = NSAttributedString(string: "Value",
                                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                      
        ValueTxtField.delegate = self
               // Do any additional setup after loading the view.
        
        
        validUntilTxtField.attributedPlaceholder = NSAttributedString(string: "Valid from",
                                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                      
        validUntilTxtField.delegate = self
        
        validLimitTxtField.attributedPlaceholder = NSAttributedString(string: "Valid until",
                                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                      
        validLimitTxtField.delegate = self
        
        numberOfUseTxtField.attributedPlaceholder = NSAttributedString(string: "Number of use",
                                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                      
        numberOfUseTxtField.delegate = self
        
               
        ValueTxtField.keyboardType = .numberPad
        numberOfUseTxtField.keyboardType = .numberPad
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        titleTxtField.becomeFirstResponder()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func createBtnPressed(_ sender: Any) {
        
        
        var count = 0
        var limit = 0
        
        if let title = titleTxtField.text, let description = DescriptionTxrField.text, let category = categoryTxtField.text, category != "", let type = TypeTxtField.text, type != "", let value = ValueTxtField.text, value != "", let startTime = validUntilTxtField.text, startTime != "", let untilTime = validLimitTxtField.text, untilTime != "" {
            
            if type == "%" {
                if Int(value)! > 100 {
                    
                    
                    self.showErrorAlert("Oops !!!", msg: "Because the type is %, so the value can't be higher than 100%, please fix and re-submit")
                    
                    return
                    
                }
                    
                
            }
            
            var dict = [String : Any]()
            
            dict = ["title": title, "description": description, "category": category, "type": type, "value": value, "restaurant_id": restaurant_id, "timeStamp": FieldValue.serverTimestamp(), "status": "Online", "category_url": "All", "fromDate": fromDate!, "untilDate": untilDate!, "Created by": "Owner" ] as [String : Any]
            
          
            swiftLoader()

            
            let db = DataService.instance.mainFireStoreRef.collection("Voucher")
            
             if let nums = numberOfUseTxtField.text  {
                
                let num = Int(nums)
                while count < num! {
                    
                    count += 1
                    db.addDocument(data: dict) { err in
                                 
                                     if let err = err {
                                         
                                         SwiftLoader.hide()
                                         self.showErrorAlert("Opss !", msg: err.localizedDescription)
                                         
                                     } else {
                                       
                                       //self.generateNotification(title: "Added \(title) voucher", description: description, type: "voucher")
                                        
                                        
                                       limit += 1
                                       if num == limit {
                                        SwiftLoader.hide()
                                                                              self.dismiss(animated: true, completion: nil)
                                        }
                                       
                                   
                                   }
                                   
                                   
                               }
                    
                }
                
            }
            
             
            
        } else {
            
            self.showErrorAlert("Oops !!!", msg: "Please fill all required field to continue")
            
            
            
        }
        
    }
    
    @IBAction func CategoryBtnPressed(_ sender: Any) {
        pickerViewController = pickView.category
        createDayPicker()
    }
    
    
    @IBAction func typeBtnPressed(_ sender: Any) {
        pickerViewController = pickView.type
        createDayPicker()
    }
    
    
    func createDayPicker() {
        
        
        let dayPicker = UIPickerView()
        dayPicker.delegate = self

        //Customizations
        
         switch (pickerViewController) {
            
            case .type:
                TypeTxtField.inputView = dayPicker
            case .category:
                categoryTxtField.inputView = dayPicker
            
        }
        
        
    }
    @IBAction func TimeChooseBtn(_ sender: Any) {
        
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePickerView.minimumDate = Date().addingTimeInterval(60 * 60 * 2)
        validUntilTxtField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(CreatePromoVC.dateFromValueChanged(_:)), for: UIControl.Event.valueChanged)
        
    }
    
    @IBAction func createLimit(_ sender: Any) {
        
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePickerView.minimumDate = Date().addingTimeInterval(60 * 60 * 24)
        validLimitTxtField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(CreatePromoVC.dateUntilValueChanged(_:)), for: UIControl.Event.valueChanged)
        
    }
    
    @objc func dateFromValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short
        //dateFormatter.dateFormat = "MM-dd-yyyy"
        validUntilTxtField.text = dateFormatter.string(from: sender.date)

        
        fromDate = sender.date
    }
    
    @objc func dateUntilValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short
        //dateFormatter.dateFormat = "MM-dd-yyyy"
        validLimitTxtField.text = dateFormatter.string(from: sender.date)
        
        untilDate = sender.date
       

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
}

extension CreatePromoVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        
        return 1
            
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        switch (pickerViewController) {
            
            case .type:
                return type.count
            case .category:
                return category.count
            
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        
        switch (pickerViewController) {
            
            case .type:
                return type[row]
            case .category:
                return category[row]
            
        }
     
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        switch (pickerViewController) {
            
            case .type:
                TypeTxtField.text = type[row]
            case .category:
                categoryTxtField.text = category[row]
            
        }

        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel!
        
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        switch (pickerViewController) {
            
            case .type:
                label.text = type[row]
            case .category:
                label.text = category[row]
            
        }

        label.textAlignment = .center
        return label

        
    }
}
