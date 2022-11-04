//
//  TwoFactorAuthenticationVC.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/3/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import SinchVerification
import Firebase
import SCLAlertView

class TwoFactorAuthenticationVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var VerifyView: UIView!
    var verification: Verification!
    var email = ""
    
    @IBOutlet weak var phoneTxtField: UITextField!

    @IBOutlet weak var label4: RoundedLabel!
    @IBOutlet weak var label3: RoundedLabel!
    @IBOutlet weak var label1: RoundedLabel!
    @IBOutlet weak var label2: RoundedLabel!
    @IBOutlet weak var HidenTxtView: UITextField!
    
    
    var phone = ""
       
    var first = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        phoneTxtField.attributedPlaceholder = NSAttributedString(string: "Phone number",
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
               
        phoneTxtField.delegate = self
        HidenTxtView.delegate = self
        
        phoneTxtField.keyboardType = .numberPad
        
        
        
        HidenTxtView.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        HidenTxtView.keyboardType = .numberPad
        
        label1.textColor = UIColor.black
        label2.textColor = UIColor.black
        label3.textColor = UIColor.black
        label4.textColor = UIColor.black
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        phoneTxtField.becomeFirstResponder()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == phoneTxtField {
            
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedNumber(number: newString)
            
            return false
        } else {
            
            return true
        }
        
    }
    
    private func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX) XXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        
        
        return result
        
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
    
    func convertPhoneNumber(Phone: String) -> String {
        
        let arr = Array(Phone)
        var new = [String]()
        
        for i in arr {
            
            if i != "(", i != ")", i != " ", i != "-" {
                
                
                new.append(String((i)))
                
            
            }
            
        }
        
        let stringRepresentation = new.joined(separator:"")
        
        
        return stringRepresentation
    }
    
    

    
    func getTextInPosition(text: String, position: Int) -> String  {
        
        let arr = Array(text)
        var count = 0
        
        for i in arr {
            
            if count == position {
                return String(i)
            } else {
                
                count += 1
            }
            
        }
        
        return "Fail"
        
        
        
        
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        
        if HidenTxtView.text?.count == 1 {
            
            
            label1.backgroundColor = BColor
            label2.backgroundColor = UIColor.placeholderText
            label3.backgroundColor = UIColor.placeholderText
            label4.backgroundColor = UIColor.placeholderText
            
            label1.text = getTextInPosition(text: HidenTxtView.text!, position: 0)
            label2.text = ""
            label3.text = ""
            label4.text = ""
            
            
            
            
            
        } else if HidenTxtView.text?.count == 2 {
            
            
            label1.backgroundColor = BColor
            label2.backgroundColor = BColor
            label3.backgroundColor = UIColor.placeholderText
            label4.backgroundColor = UIColor.placeholderText
            
            label2.text = getTextInPosition(text: HidenTxtView.text!, position: 1)
            label3.text = ""
            label4.text = ""
            
            
        } else if HidenTxtView.text?.count == 3 {
            
            label1.backgroundColor = BColor
            label2.backgroundColor = BColor
            label3.backgroundColor = BColor
            label4.backgroundColor = UIColor.placeholderText
            
            label3.text = getTextInPosition(text: HidenTxtView.text!, position: 2)
            label4.text = ""
            
        } else if HidenTxtView.text?.count == 4 {
            
            label1.backgroundColor = BColor
            label2.backgroundColor = BColor
            label3.backgroundColor = BColor
            label4.backgroundColor = BColor
            
            label4.text = getTextInPosition(text: HidenTxtView.text!, position: 3)
            
            
            if let code = HidenTxtView.text, code != "" {
                
                self.verifyCode(code: code)
                
            } else {
                
                label1.backgroundColor = UIColor.placeholderText
                label2.backgroundColor = UIColor.placeholderText
                label3.backgroundColor = UIColor.placeholderText
                label4.backgroundColor = UIColor.placeholderText
                
                label1.text = ""
                label2.text = ""
                label3.text = ""
                label4.text = ""
                
                HidenTxtView.text = ""
                
                self.showErrorAlert("Ops !", msg: "Invalid code, please try again")
                
            }
            
        } else if HidenTxtView.text?.count == 0 {
            
            label1.backgroundColor = UIColor.placeholderText
            label2.backgroundColor = UIColor.placeholderText
            label3.backgroundColor = UIColor.placeholderText
            label4.backgroundColor = UIColor.placeholderText
            
            label1.text = ""
            label2.text = ""
            label3.text = ""
            label4.text = ""
            
            HidenTxtView.text = ""
        }
        
        
    }
    
    func verifyCode(code: String) {
        

       self.swiftLoader()
        
        verification.verify(
            code, completion:
            { (success:Bool, error:Error?) -> Void in
                
                if (success) {
                    
                    self.processSignIn(phone: self.phone)
                         
                    
                } else {
                    
                    
                    self.label1.backgroundColor = UIColor.placeholderText
                    self.label2.backgroundColor = UIColor.placeholderText
                    self.label3.backgroundColor = UIColor.placeholderText
                    self.label4.backgroundColor = UIColor.placeholderText
                    
                    self.label1.text = ""
                    self.label2.text = ""
                    self.label3.text = ""
                    self.label4.text = ""
                    
                    self.HidenTxtView.text = ""
                    SwiftLoader.hide()
                    
                    self.showErrorAlert("Opss!", msg: (error?.localizedDescription)!)
                    
                    
                    
                }
                
                
        })
        
        
        
    }
    
    func processSignIn(phone: String) {
        
    
        DataService.instance.mainFireStoreRef.collection("Admin-List").whereField("Email", isEqualTo: email).whereField("Status", isEqualTo: true).getDocuments{ (snap, err) in
        
            if err != nil {
            
                SwiftLoader.hide()
                self.showErrorAlert("Opss !", msg: err!.localizedDescription)
                print(err?.localizedDescription as Any)
                return
            
            }
            
            if snap?.isEmpty == true {
                
                SwiftLoader.hide()
                try! Auth.auth().signOut()
                self.showErrorAlert("Opss !", msg: "Can't process your account this time, please contact support")
                          
            } else {
                    
                for item in snap!.documents {
                  
                    let id = item.documentID
                    
                    if self.first == true {
                        
                         DataService.instance.mainRealTimeDataBaseRef.child("Two_factor_authentication").child(Auth.auth().currentUser!.uid).child(self.phone).setValue(["Timestamp": ServerValue.timestamp()])
                        DataService.instance.mainFireStoreRef.collection("Admin_list").document(id).updateData(["Phone": phone])
                        
                    }
                    
                    SwiftLoader.hide()
                    self.performSegue(withIdentifier: "moveToMainVC", sender: nil)
                    

                }
                
            }
            
            
        }
    
        
        
        
    }
    
    @IBAction func NextBtnPressed(_ sender: Any) {

        if let phone = phoneTxtField.text, phone != "" {
              
              let converted = convertPhoneNumber(Phone: phone)
        
              if converted.count != 10 {
                  
                  self.showErrorAlert("Ops !", msg: "Your phone number is invalid")
                  
              } else {
                
                self.swiftLoader()
                var finalPhone = ""
                
                if converted == "0879565629" {
                
                    finalPhone = "+84879565629"
                    
                } else {
                    
                    
                    finalPhone = "+1\(converted)"
                    
                }
                
                DataService.instance.mainRealTimeDataBaseRef.child("Two_factor_authentication").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapData) in
                        
                if snapData.exists() {
                    
                    DataService.instance.mainRealTimeDataBaseRef.child("Two_factor_authentication").child(Auth.auth().currentUser!.uid).child(finalPhone).observeSingleEvent(of: .value, with: { (snapcheck) in
                        
                        if snapcheck.exists() {
                            
                            self.first = false
                            
                            self.verification = SMSVerification(applicationKey, phoneNumber: finalPhone)
                            
                            
                            self.verification.initiate { (result: InitiationResult, error:Error?) -> Void in
                                
                                if error != nil {
                                    
                                    SwiftLoader.hide()
                                    self.showErrorAlert("Ops!!!", msg: (error?.localizedDescription)!)
                                                         
                                    return
                                    
                                }
                                
                                self.phone = finalPhone
                                SwiftLoader.hide()
                                self.view.endEditing(true)
                                self.VerifyView.isHidden = false
                                self.HidenTxtView.becomeFirstResponder()
                                
                            }
                            
                            
                        } else {
                            
                            SwiftLoader.hide()
                            self.showErrorAlert("Opss!!!", msg: "This phone number doesn't belong to this account")
                            
                        }
                        
                        
                        
                    })
                    
                    
                    
                } else {
                    
                    self.first = true
                    
                    self.verification = SMSVerification(applicationKey, phoneNumber: finalPhone)
                    
                    
                    self.verification.initiate { (result: InitiationResult, error:Error?) -> Void in
                        
                        if error != nil {
                            
                            SwiftLoader.hide()
                            self.showErrorAlert("Ops!!!", msg: (error?.localizedDescription)!)
                                                 
                            return
                            
                        }
                        
                        self.phone = finalPhone
                        SwiftLoader.hide()
                        self.view.endEditing(true)
                        self.VerifyView.isHidden = false
                        self.HidenTxtView.becomeFirstResponder()
                        
                        
                        
                    }
                    
                    
                }
                    
                })

                  
                  
              }
              
          } else {
              
              SwiftLoader.hide()
              self.showErrorAlert("Ops!!!", msg: "Please enter your phone number")
              
          }
        
    }

 

}
