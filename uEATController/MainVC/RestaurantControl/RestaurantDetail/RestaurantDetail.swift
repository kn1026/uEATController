//
//  RestaurantDetail.swift
//  uEATController
//
//  Created by Khoi Nguyen on 7/9/20.
//  Copyright © 2020 Khoi Nguyen. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import AlamofireImage
import Alamofire

class RestaurantDetail: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var RestaurantMode: UISwitch!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var webLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    var marker = GMSMarker()
    var id = ""
    
    
    var transItem: RestaurantModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        
        styleMap()
        
        
        
        if transItem.Restaurant_url != "" {
            
            
            imageStorage.async.object(forKey: transItem.Restaurant_url) { result in
                if case .value(let image) = result {
                    
                    DispatchQueue.main.async { // Make sure you're on the main thread here
                        
                        
                        self.icon.image = image
                        
                        //try? imageStorage.setObject(image, forKey: url)
                        
                    }
                    
                } else {
                    
                    
                    AF.request(self.transItem.Restaurant_url).responseImage { response in
                        
                        
                        switch response.result {
                        case let .success(value):
                            self.icon.image = value
                            try? imageStorage.setObject(value, forKey: self.transItem.Restaurant_url)
                        case let .failure(error):
                            print(error)
                        }
                        
                        
                        
                    }
                    
                }
                
            }
            
            
            
        }
        
       

        
        self.nameLbl.text = transItem.Restaurant_name
        
        self.addressLbl.text = transItem.Restaurant_address
        
        self.phoneLbl.text = transItem.Restaurant_phone
        
        self.emailLbl.text = transItem.Restaurant_email
        
        self.webLbl.text = transItem.website
        
        
        let location = CLLocationCoordinate2D(latitude: transItem.Lat, longitude: transItem.Lon)

        self.centerMapOnUserLocation(location: location)
        
        self.loadIsOpen()
        
    }
    
    func styleMap() {
    
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "customizedMap", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    
    
    
    }
    
    
    func centerMapOnUserLocation(location: CLLocationCoordinate2D) {
           

           // get MapView
           let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 17)
           

           self.marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
        
           marker.position = location
        
           marker.map = mapView
           mapView.camera = camera
           mapView.animate(to: camera)
           marker.appearAnimation = GMSMarkerAnimation.pop
           
           
           marker.isTappable = false
           
            
           
    }
    
    func loadIsOpen() {
        
        //Open
        
        DataService.instance.mainFireStoreRef.collection("Restaurant").whereField("Email", isEqualTo: transItem.Restaurant_email!).getDocuments { (snap, err) in
            
            if err != nil {
            
                SwiftLoader.hide()
                self.showErrorAlert("Opss !", msg: "Can't validate your menu")
                return
            
            }
            
            
            if snap?.isEmpty == true {
                
                SwiftLoader.hide()
                self.showErrorAlert("Opss !", msg: "Your account isn't ready yet, please wait until getting an email from us or you can contact our support")
                          
            } else {
                
                
                for item in snap!.documents {
                    
                    
                    
                    
                    if let openStatus = item.data()["Status"] as? String {
                        
                        if openStatus == "Ready" {
                            
                            self.RestaurantMode.setOn(true, animated: true)
                            
                        } else {
                            
                            self.RestaurantMode.setOn(false, animated: true)
                            
                        }
                    } else  {
                        
                        self.RestaurantMode.setOn(false, animated: true)
                        
                    }
                    
                    
                    
                    
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

    @IBAction func MenuBtnPressed(_ sender: Any) {
        
        
        id = transItem.Restaurant_id
        
        self.performSegue(withIdentifier: "moveToMenuVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "moveToMenuVC"{
            if let destination = segue.destination as? MenuVC {
                
                destination.id = id
                
                
            }
        }
        
    }
    
    @IBAction func changeRestaurantModeBtnPressed(_ sender: Any) {
    
        
        if RestaurantMode.isOn == true {
            
            let alert = UIAlertController(title: "Notice !!!", message: "If you confirm this action, this restaurant is ready and able to take order from now on.", preferredStyle: UIAlertController.Style.alert)

            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { action in

                DataService.instance.mainFireStoreRef.collection("Restaurant").document(self.transItem.Restaurant_id).updateData(["Status": "Ready"])
                
                var phone = ""
                if self.transItem.Restaurant_phone == "0879565629" {
                    phone = "+8489565629"
                } else {
                    
                    phone = "+1\(self.transItem.Restaurant_phone!)"
                    self.sendSmsNoti(Phone: phone, text: "Congratulation, your application is accepted and you are available to sell on our platform, we're very happy to have you on board !")
                    
                }

            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            
            
           
            
        } else {
            
            let alert = UIAlertController(title: "Notice !!!", message: "If you confirm this action, this restaurant will return to pending mode, disable from taking orders.", preferredStyle: UIAlertController.Style.alert)

            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { action in

                DataService.instance.mainFireStoreRef.collection("Restaurant").document(self.transItem.Restaurant_id).updateData(["Status": "Pending", "Open": false])
                
                var phone = ""
                if self.transItem.Restaurant_phone == "0879565629" {
                    phone = "+8489565629"
                } else {
                    
                    phone = "+1\(self.transItem.Restaurant_phone!)"
                    self.sendSmsNoti(Phone: phone, text: "Notice, your restaurant is temporarily closed by our administration due to some issues, please contact us to solve it and make you online again!")
                    
                }

            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
            

            
        }
        
        
    }
    
    
    func sendSmsNoti(Phone: String, text: String) {
        
        let url = MainAPIClient.shared.baseURLString
        let urls = URL(string: url!)?.appendingPathComponent("sms_noti")
        
        AF.request(urls!, method: .post, parameters: [
            
            "phone": Phone,
            "body": text
            
            
            ])
            
            .validate(statusCode: 200..<500)
            .responseJSON { responseJSON in
                
                switch responseJSON.result {
                    
                    
                case .success(let json):
                    
                    print( json)
                    
                case .failure(let err):
                    
                    print(err)
                }
                
        }
        
    }
    
    
    
    
}
