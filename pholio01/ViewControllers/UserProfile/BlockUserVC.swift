//
//  BlockUserVC.swift
//  pholio01
//
//  Created by Chris  Ransom on 4/8/22.
//  Copyright © 2022 Chris Ransom. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseStorage

class BlockUserVC: UIViewController {
    
    @IBOutlet weak var popUPView: UIView!
    
    var pageIndex : Int = 0
    var ref = Database.database().reference()

    let userID = Auth.auth().currentUser?.uid

    let location: String = "Gateway Arch Park"
    
    var profilevc: ProfileVC!

    
    
    
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
        
        let userUid = profilevc.usersArray[pageIndex]
      
       
        
            
       
            
            Database.database().reference().child("reported-users").childByAutoId().child("userId").setValue(userUid)
        
        dismiss(animated: true)

       print("Blocked User!")
        
    }
    
    
    
    
    
    
    
}
