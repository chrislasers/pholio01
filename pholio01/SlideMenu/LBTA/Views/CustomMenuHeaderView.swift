//
//  CustomMenuHeaderView.swift
//  SlideOutMenuLBTA
//
//  Created by Brian Voong on 10/2/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import Kingfisher


class CustomMenuHeaderView: UIView {
    
    let nameLabel = UILabel()
    let usernameLabel = UILabel()
    let statsLabel = UILabel()
    var profileImageView = ProfileImageView()
    
   // var ref: DatabaseReference!
    
    let userID: String = (Auth.auth().currentUser?.uid)!
    
   let  ref = Database.database().reference()
    
    var users: Users?



    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupComponentProps()
        setupStackView()
    }
    
    fileprivate func setupComponentProps() {
        // custom components for our header
        
        
        
        let ref = Database.database().reference().child("Users").child(userID)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let snap = snapshot.value as? [String : AnyObject] {
                if let result = snap["Username"] as? String {
                    self.nameLabel.text! = result
                }else {
                    print("USERNAME not displayed")            }
            }else{
                print("maybe USER UID not exist in database ")
            }
        })
        
        
        nameLabel.text = "Brian Voong"
        nameLabel.font =  UIFont.init(name: "Helvetica-Bold", size: 22)
         nameLabel.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
       // usernameLabel.text = "@buildthatapp"
      //  statsLabel.text = "42 Following 7091 Followers"
        //profileImageView.image = UIImage(named: "girl_profile")
        
        DBService.shared.refreshUser(userId: (Auth.auth().currentUser?.uid)!) { (user) in
            
            let imageUrl = URL(string: user.profileImageUrl!)!
            self.profileImageView.kf.indicatorType = .activity
            self.profileImageView.kf.setImage(with: imageUrl)
            /*
             DispatchQueue.global(qos: .background).async {
             let imageData = NSData(contentsOf: URL(string: user.profileImageUrl!)!)
             
             DispatchQueue.main.async {
             let profileImage = UIImage(data: imageData! as Data)
             self.userProfileImage.image = profileImage
             }
             }
             */
        }
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 160 / 2
        profileImageView.clipsToBounds = true
        
        //setupStatsAttributedText()
    }
    
    fileprivate func setupStatsAttributedText() {
        statsLabel.font = UIFont.systemFont(ofSize: 14)
        let attributedText = NSMutableAttributedString(string: "42 ", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .medium)])
        attributedText.append(NSAttributedString(string: "Following  ", attributes: [.foregroundColor: UIColor.black]))
        attributedText.append(NSAttributedString(string: "7091 ", attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .medium)]))
        attributedText.append(NSAttributedString(string: "Followers", attributes: [.foregroundColor: UIColor.black]))
        
        statsLabel.attributedText = attributedText
    }
    
    fileprivate func setupStackView() {
        // this is a spacing hack with UIView
        let rightSpacerView = UIView()
        let arrangedSubviews = [
            //            UIView(),
            UIStackView(arrangedSubviews: [profileImageView, rightSpacerView]),
            SpacerView(space: 20),
            nameLabel,
            usernameLabel,
            statsLabel
        ]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 7
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 75, left: 24, bottom: 24, right: 24)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
