//
//  PairWithVC.swift
//  pholio01
//
//  Created by Chris  Ransom on 4/14/18.
//  Copyright © 2018 Chris Ransom. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseStorage
import Pastel
import MapKit
import CoreLocation
import GeoFire


class PairWithVC: UIViewController, CLLocationManagerDelegate {
    
    
    var ref: DatabaseReference!
    
    var locationManager = CLLocationManager()
      var currentLocation: CLLocation!
      

      var geoFireRef: DatabaseReference?
      var geoFire: GeoFire!
    
    let userID = Auth.auth().currentUser?.uid
    let Photographer: String = "Photographer"
    let Model: String = "Model"
    let Guest: String = "Guest"
    let Man: String = "Man"
    let Woman: String = "Woman"
    let Models: String = "Finished"

    
    @IBOutlet weak var firstPair: UIButton!
    
    @IBOutlet weak var secondPair: UIButton!
    
    @IBOutlet weak var map: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "back"), for: .normal)
        //add function for button
        button.addTarget(self, action: #selector(fbButtonPressed), for: .touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 21, height: 21)
        
        let widthConstraint = button.widthAnchor.constraint(equalToConstant: 21)
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 21)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
        
        
        firstPair.center.x = self.view.frame.width + 30
        secondPair.center.x = self.view.frame.width + 30
        
        
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0,initialSpringVelocity: 5, options: [], //options: nil
            animations: ({
                
                self.firstPair.center.x = self.view.frame.width / 2
                
                
            }), completion: nil)
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1.0,initialSpringVelocity: 6, options: [], //options: nil
            animations: ({
                
                self.secondPair.center.x = self.view.frame.width / 2
                
                
            }), completion: nil)
        
        
        firstPair.backgroundColor = UIColor.orange
        firstPair.setTitle("Photographer", for: .normal)
        firstPair.layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
        firstPair.layer.borderWidth = 1.5
        firstPair.layer.cornerRadius = 4
        firstPair.setTitleColor(UIColor.white, for: .normal)
        //signUp.layer.shadowColor = UIColor.white.cgColor
        // signUp.layer.shadowRadius = 5
        firstPair.layer.shadowOpacity = 0.5
        firstPair.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        
        secondPair.backgroundColor = UIColor.orange
        secondPair.setTitle("Model", for: .normal)
        secondPair.layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
        secondPair.layer.borderWidth = 1.5
        secondPair.layer.cornerRadius = 4
        secondPair.setTitleColor(UIColor.white, for: .normal)
        //signUp.layer.shadowColor = UIColor.white.cgColor
        // signUp.layer.shadowRadius = 5
        secondPair.layer.shadowOpacity = 0.5
        secondPair.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        
        
       
        map.isHidden = true
           map.showsUserLocation = true
           
           map.delegate = self as? MKMapViewDelegate
           
           locationManager = CLLocationManager()
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestWhenInUseAuthorization()
           locationManager.startUpdatingLocation()
           
           geoFireRef = Database.database().reference()
           
           geoFire = GeoFire(firebaseRef: (geoFireRef!.child("user_locations")))

        
        ref =
            Database.database().reference()
        
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if Auth.auth().currentUser?.uid != nil {
                print("Usertype Successful")
                
                
            }
                
            else {
                print("User Not Signed In")
                // ...
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        let pastelView = PastelView(frame: view.bounds)
        
        //MARK: -  Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        //MARK: -  Custom Duration
        
        pastelView.animationDuration = 3.00
        
        //MARK: -  Custom Color
        pastelView.setColors([
            
            UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
            
            
            UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
            
            
            
            UIColor(red: 50/255, green: 157/255, blue: 240/255, alpha: 1.0)])
        
        //   UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
        
        
        //  UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 1)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationAuthStatus() {
           
           if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
               
               
               
               currentLocation = locationManager.location
               
               print(currentLocation.coordinate.longitude)
               print(currentLocation.coordinate.latitude)
               
               
           } else {
               locationManager.requestWhenInUseAuthorization()
               locationAuthStatus()
           }
       }
       
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Error")
       }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           
           let location = locations[0]
           
           let spanz:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
           
           let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
           
           let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation,span: spanz)
           
           map.setRegion(region, animated: true)
           
           guard locations.last != nil else { return }
           geoFire!.setLocation(location, forKey: (Auth.auth().currentUser?.uid)!)
           
           let locationRef = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid)
           locationRef.child("lat_lon").setValue("\(location.coordinate.latitude)_\(location.coordinate.longitude)")
           
           print(location.coordinate)
           
           self.map.showsUserLocation = true
           
           
       }
       
      
    
    @objc func fbButtonPressed() {
        
        dismiss(animated: true, completion: nil)

        
        print("Bar Button Pressed")
    }
    
    
    @IBAction func canceledPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func pPressed(_ sender: Any) {
        
        
        self.ref.child("Users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["Pairing With": Photographer])
        
        
        self.ref.child("Users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["PairingFilter": PairingFilter.photographer.rawValue])
        
        
        self.performSegue(withIdentifier: "toEditProfile", sender: nil)
        
        
              let childupdates: [String: Any] = [
                  "/Yes": Models,
          ]
        
        let userRef = ref.child("Users").child(Auth.auth().currentUser!.uid)
        userRef.updateChildValues(childupdates)
    }
    
    @IBAction func mPressed(_ sender: Any) {
        
        self.ref.child("Users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["Pairing With": Model])
        self.ref.child("Users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["PairingFilter": PairingFilter.model.rawValue])
        self.performSegue(withIdentifier: "toEditProfile", sender: nil)
        
        
              let childupdates: [String: Any] = [
                  "/Yes": Models,
          ]
        
        let userRef = ref.child("Users").child(Auth.auth().currentUser!.uid)
        userRef.updateChildValues(childupdates)
    }
    
    
    
    
}
