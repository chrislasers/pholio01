//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import Kingfisher


protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /**
     *  Array to display menu options
     */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
     *  Transparent button to hide menu
     */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
     *  Array containing menu options
     */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    /**
     *  Menu button which was tapped to display the menu
     */
    var btnMenu : UIButton!
    
    /**
     *  Delegate of the MenuVC
     */
    var delegate : SlideMenuDelegate?
    
    @IBOutlet var userProfileImage: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var usertype: UILabel!
    
    var ref: DatabaseReference!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if Auth.auth().currentUser != nil
            {
                print("User Signed In")
                //self.performSegue(withIdentifier: "homepageVC", sender: nil)    }
                
            }  else {
                
                
                print("User Not Signed In")
            }
        }
        
    getProfileImage()
        
        //fetchCurrentUser()
        
        self.tblMenuOptions.tableFooterView = UIView()
        
        let userID: String = (Auth.auth().currentUser?.uid)!
        
        
        ref = Database.database().reference()
        
        
        self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.height / 2;
        self.userProfileImage.layer.borderColor = UIColor.white.cgColor
        self.userProfileImage.layer.borderWidth = 1.5
        self.userProfileImage.clipsToBounds = true
        userProfileImage.contentMode = .scaleAspectFill
        self.userProfileImage.layer.shadowRadius = 7
        self.userProfileImage.layer.shadowOpacity = 0.6
        self.userProfileImage.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
        
        ref = Database.database().reference().child("Users").child(userID)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let snap = snapshot.value as? [String : AnyObject] {
                if let result = snap["Username"] as? String {
                    self.username.text = result
                }else {
                    print("USERNAME not displayed")            }
            }else{
                print("maybe USER UID not exist in database ")
            }
        })
        
        ref = Database.database().reference().child("Users").child(userID)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let snap = snapshot.value as? [String : AnyObject] {
                if let result = snap["Usertype"] as? String {
                    self.usertype.text = result
                }else {
                    print("USERTYPE not displayed")
                }
            }else{
                print("maybe USER UID not exist in database ")
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
        arrayMenuOptions.append(["title":"Home", "icon":"real-estate"])
        arrayMenuOptions.append(["title":"Request", "icon":"add-user"])
        arrayMenuOptions.append(["title":"Filters", "icon":"filter-3"])
        arrayMenuOptions.append(["title":"Get Help", "icon":"question-2"])
        arrayMenuOptions.append(["title":"Settings", "icon":"settings-3"])
        arrayMenuOptions.append(["title":"Log Out", "icon":"logout-2"])
        
        
        tblMenuOptions.reloadData()
    }
    
    var users: Users?
    
    func fetchCurrentUser() {
        // fetch some Firestore Data
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("Users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            
            // fetched our user here
            guard let dictionary = snapshot?.data() else { return }
            self.users = Users(dictionary: dictionary)
            self.loadUserPhotos()
            
            self.tblMenuOptions.reloadData()
        }
    }
    
    func loadUserPhotos() {
        
        let imageUrl = URL(string: users!.imageUrl1!)!
        
        
        self.userProfileImage.kf.indicatorType = .activity
        self.userProfileImage.kf.setImage(with: imageUrl)
        
        
    }
    
    

    
    
    func getProfileImage() {
        DBService.shared.refreshUser(userId: (Auth.auth().currentUser?.uid)!) { (user) in
            
            let imageUrl = URL(string: user.profileImageUrl!)!
            self.userProfileImage.kf.indicatorType = .activity
            self.userProfileImage.kf.setImage(with: imageUrl)
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
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
}
