//
//  NewMatchCollectionViewCell.swift
//  pholio01
//
//  Created by Chris  Ransom on 8/23/18.
//  Copyright © 2018 Chris Ransom. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import Kingfisher
import FirebaseFirestore

class NewMatchCollectionViewCell: UICollectionViewCell {
    
    
    
    var user: UserModel? {
        didSet {
            let toId = user?.userId
            Database.database().reference().child("Users").child(toId!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.usernameLabel.text = dictionary["Username"] as? String
                }
            }, withCancel: nil)

            
        }
    }
    
    
    
    
    
    @IBOutlet weak var imageARRAY: UIImageView!
    
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    var currentUser: UserModel!
    var matchedUsers = [UserModel]()
    
    var usersArray = [UserModel]()
    var seenUsersArray = [UserModel]()
        
  
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        

        
       
        self.imageARRAY.layer.cornerRadius = self.imageARRAY.frame.size.height / 2;
       // self.imageARRAY.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
       // self.imageARRAY.layer.borderWidth = 1.25
        self.imageARRAY.clipsToBounds = true
        setShadow()
        
//
//        self.imageARRAY.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
//
    //   self.imageARRAY.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//
//        self.imageARRAY.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        self.imageARRAY.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    func setupNameAndProfileImage() {

    
        if let id = user?.userId {
        
      
        let ref = Database.database().reference().child("Users").child(id)
           ref.observeSingleEvent(of:.value, with: { (snapshot) in
           
           if let dictionary = snapshot.value as? [String: AnyObject] {
               self.usernameLabel?.text = dictionary["Username"] as? String
               
           }
           print(snapshot)

           
       }, withCancel: nil)
        
    }
    }
    
    
    
    
    private func setShadow() {
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 5.0)
        layer.shadowRadius  = 6.5
        layer.shadowOpacity = 0.4
        clipsToBounds       = true
        layer.masksToBounds = false
    }
    
}
