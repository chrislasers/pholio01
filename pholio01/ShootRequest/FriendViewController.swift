//
//  FriendViewController.swift
//  pholio01
//
//  Created by Chris  Ransom on 11/9/18.
//  Copyright © 2018 Chris Ransom. All rights reserved.
//

import UIKit


class FriendViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FriendSystem.system.addFriendObserver {
            self.tableView.reloadData()
        }
    }
}

extension FriendViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendSystem.system.friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        if cell == nil {
            tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        }
        
        // Modify cell
        cell!.button.setTitle("Remove", for: UIControl.State())
        cell!.emailLabel.text = FriendSystem.system.friendList[indexPath.row].email
        
        cell!.setFunction {
            let id = FriendSystem.system.friendList[indexPath.row].userId
            FriendSystem.system.removeFriend(id!)
        }
        
        // Return cell
        return cell!
    }
    
}
