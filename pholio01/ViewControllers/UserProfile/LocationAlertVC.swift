//
//  LocationAlertVC.swift
//  pholio01
//
//  Created by Chris  Ransom on 3/26/22.
//  Copyright © 2022 Chris Ransom. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseStorage
class LocationAlertVC: UIViewController {
    
    @IBOutlet weak var popUPView: UIView!
    
    
    var ref = Database.database().reference()

    let userID = Auth.auth().currentUser?.uid

    let location: String = "Gateway Arch Park"
    
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUPView.layer.cornerRadius = 4.0
        popUPView.layer.shadowColor = UIColor.black.cgColor
        popUPView.layer.shadowOpacity = 0.5
        popUPView.layer.shadowOffset = .zero
        popUPView.layer.shadowRadius = 5
        
//        //circlerView.layer.cornerRadius = circlerView.frame.height / 2
//        circlerView.layer.shadowColor = UIColor.black.cgColor
//        circlerView.layer.shadowOpacity = 0.5
//        circlerView.layer.shadowOffset = .zero
//        circlerView.layer.shadowRadius = 5
//
//        innerCircleView.layer.cornerRadius = innerCircleView.frame.height / 2
}
    
    @IBAction func noBTN(_ sender: Any) {
        dismiss(animated: true)
        
    }
    
    @IBAction func yesBTN(_ sender: Any) {
        self.ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("Photoshoot Location").updateChildValues(["Photoshoot Location": location])
        
        
        dismiss(animated: true)
        

       print("Location Accepted!")
        
    }
    
    
    
    
    
    
    
}
