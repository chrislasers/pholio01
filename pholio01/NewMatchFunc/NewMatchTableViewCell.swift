//
//  NewMatchTableViewCell.swift
//  
//
//  Created by Chris  Ransom on 8/23/18.
//

import UIKit
import Firebase
import Kingfisher


class NewMatchTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var moreImages: UIImageView!
    
    @IBOutlet weak var newLabel: UILabel!
    
    @IBOutlet weak var timeLABEL: UILabel!
    
    var currentUser: UserModel!
    
   var matchedUsers = [UserModel]()
    
   var user = [User]()

    var message: Message? {
        didSet {
            setupNameAndProfileImage()
            
            detailTextLabel?.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                timeLabel.text = dateFormatter.string(from: timestampDate)
            }
            
            
        }
    }
    
    func setupNameAndProfileImage() {
        
        
        if let id = message?.chatPartnerId() {
            
         let ref = Database.database().reference().child("Users").child(id)
            ref.observeSingleEvent(of:.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.textLabel?.text = dictionary["Username"] as? String
                    
                    if let userProfilePicDictionary = dictionary["UserPro-Pic"] as? [String: Any] {
                        if let profileImageUrl = userProfilePicDictionary["profileImageURL"] as? String {
                            
                            
                            
                            let imageUrl = URL(string: profileImageUrl)
                            self.profileImageView.kf.indicatorType = .activity
                            self.profileImageView.kf.setImage(with: imageUrl)
                        }
                    }
                    
                }
                print(snapshot)

                
            }, withCancel: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 138, y: textLabel!.frame.origin.y - 30, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 138, y: detailTextLabel!.frame.origin.y - 25, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 55
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        //        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
       profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        //need x,y,width,height anchors
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 23).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 11).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
