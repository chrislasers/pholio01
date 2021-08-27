//
//  MenuController.swift
//  SlideOutMenuLBTA
//
//  Created by Brian Voong on 9/25/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookLogin


struct MenuItem {
    let icon: UIImage
    let title: String
}

extension MenuController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
//
//               let slidingController = BViewController()
//        slidingController.didSelectMenuItem(indexPath: indexPath)
//
        if let bViewController = navigationController?.topViewController as? BViewController {
            
            bViewController.handleHide()
        }

        
       if(indexPath.row == 1)
       {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "Request") as! RequestViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
       }

//       } else if(indexPath.row == 2) {
//
//           let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//          let controller = storyboard.instantiateViewController(withIdentifier: "Filters") as! FiltersVC
//
//          self.navigationController?.pushViewController(controller, animated: true)
//
//
//       }
//
//    else if(indexPath.row == 4) {
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        let controller = storyboard.instantiateViewController(withIdentifier: "NewSettings") as! NewEditProfile
//
//        self.navigationController?.pushViewController(controller, animated: true)
//
//       }
       
       else if(indexPath.row == 2) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "Request") as! RequestViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
       }
       
       
       else if(indexPath.row == 3) {
        
        
        print("LogOut\n", terminator: "")
        
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { (action) in
            
            guard Auth.auth().currentUser != nil else {
                return
            }
            
            do {
                
                // Check provider ID to verify that the user has signed in with Apple
                   if
                       let providerId = Auth.auth().currentUser?.providerData.first?.providerID,
                       providerId == "apple.com" {
                       // Clear saved user ID
                       UserDefaults.standard.set(nil, forKey: "appleAuthorizedUserIdKey")
                   }
                   
                
                   let firebaseAuth = Auth.auth()
                do {
                  try firebaseAuth.signOut()
                } catch let signOutError as NSError {
                  print ("Error signing out: %@", signOutError)
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let signinvc = storyboard.instantiateViewController(withIdentifier: "signinvc")
                
                self.present(signinvc, animated: true, completion: nil)
                
                
                print("User Signed Out")
                
                
            } catch let signOutError as NSError {
                
                Service.showAlert(on: self, style: .alert, title: "Sign Out Error", message: NSLocalizedDescriptionKey)
                
                print ("Error signing out: %@", signOutError)
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Service.showAlert(on: self, style: .actionSheet, title: nil, message: nil, actions: [signOutAction, cancelAction], completion: nil)
        }
}
}

class MenuController: UITableViewController {
    
    
    let menuItems = [
        MenuItem(icon: #imageLiteral(resourceName: "real-estate"), title: "Home"),
        MenuItem(icon: #imageLiteral(resourceName: "add-user"), title: "Request"),
        //MenuItem(icon: #imageLiteral(resourceName: "filter-3"), title: "Filters"),
        MenuItem(icon: #imageLiteral(resourceName: "question-2"), title: "Get Help"),
       // MenuItem(icon: #imageLiteral(resourceName: "settings-4"), title: "Settings"),
        MenuItem(icon:  #imageLiteral(resourceName: "logout-2"), title: "Log Out"),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customHeaderView = CustomMenuHeaderView()
        return customHeaderView
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MenuItemCell(style: .subtitle, reuseIdentifier: "cellId")
        let menuItem = menuItems[indexPath.row]
        cell.iconImageView.image = menuItem.icon
        cell.titleLabel.font = UIFont.init(name: "Copperplate-Bold", size: 22)
        cell.titleLabel.text = menuItem.title
         cell.titleLabel.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        cell.backgroundColor = UIColor.black

        
        return cell
    }
    
}
