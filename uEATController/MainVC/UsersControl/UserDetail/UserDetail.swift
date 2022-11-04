//
//  UserDetail.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/9/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class UserDetail: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var campusTxtField: UITextField!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var birthdayTxtField: UITextField!
    @IBOutlet weak var genderTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    var transItem: userModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if transItem.url != "" {
            
            
            imageStorage.async.object(forKey: transItem.url) { result in
                if case .value(let image) = result {
                    
                    DispatchQueue.main.async { // Make sure you're on the main thread here
                        
                        
                        self.avatarImg.image = image
                        
                        //try? imageStorage.setObject(image, forKey: url)
                        
                    }
                    
                } else {
                    
                    
                    AF.request(self.transItem.url).responseImage { response in
                        
                        
                        switch response.result {
                        case let .success(value):
                            self.avatarImg.image = value
                            try? imageStorage.setObject(value, forKey: self.transItem.url)
                        case let .failure(error):
                            print(error)
                        }
                        
                        
                        
                    }
                    
                }
                
            }
            
            
            
        }
        
        campusTxtField.attributedPlaceholder = NSAttributedString(string: transItem.campus,
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
               
        campusTxtField.delegate = self
        
        nameTxtField.attributedPlaceholder = NSAttributedString(string: transItem.Name,
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
               
        nameTxtField.delegate = self
        
        
        birthdayTxtField.attributedPlaceholder = NSAttributedString(string: transItem.Birthday,
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
               
        birthdayTxtField.delegate = self
        
        genderTxtField.attributedPlaceholder = NSAttributedString(string: transItem.Gender,
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
               
        genderTxtField.delegate = self
        
        phoneTxtField.attributedPlaceholder = NSAttributedString(string: transItem.Phone,
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
               
        phoneTxtField.delegate = self
        
        
        emailTxtField.attributedPlaceholder = NSAttributedString(string: transItem.Email,
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
               
        emailTxtField.delegate = self
        
        
    }
    
    
    @IBAction func birthdayBtnPressed(_ sender: Any) {
        
        
        
        
    }
    
    
    @IBAction func genderBtnPressed(_ sender: Any) {
        
        
        
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        
        
        
    }
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
