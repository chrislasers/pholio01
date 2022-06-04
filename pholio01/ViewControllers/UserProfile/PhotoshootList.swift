//
//  PhotoshootList.swift
//  pholio01
//
//  Created by Chris  Ransom on 9/14/21.
//  Copyright © 2021 Chris Ransom. All rights reserved.
//


import UIKit
import AVFoundation
import AVKit
import Firebase
import CTSlidingUpPanel
import Cosmos
import Firebase
import FirebaseAuth
import Kingfisher
import SwiftUI
import Lottie
import UserNotifications





class PhotoshootList: UIViewController, UITableViewDelegate {
   

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    
    
//    var toDoItems: [ToDoItem] = []
    var toDoItems = ToDoItems()
    var shootlist = ["Forest Park", "Art Hill", "The Zoo", "Elk Park"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        tableView.delegate = self
        tableView.dataSource = self
        
        toDoItems.loadData {
            self.tableView.reloadData()
        }
        LocalNotificationManager.autherizeLocalNotifications(viewController: self)


        // Do any additional setup after loading the view.
    }
    
  
    func saveData() {
    toDoItems.saveData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
        let destintion = segue.destination as! PhotoShootTableVC
            let selectedIndexPath = tableView.indexPathForSelectedRow
            destintion.toDoItem = toDoItems.itemsArray[selectedIndexPath!.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
            
        }
    }
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue)  {
        
        let source = segue.source as! PhotoShootTableVC
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            toDoItems.itemsArray[selectedIndexPath.row] = source.toDoItem
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        
        } else {
            let newIndexPath = IndexPath(row: toDoItems.itemsArray.count, section: 0)
            toDoItems.itemsArray.append(source.toDoItem)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        saveData()
    }
    
    @IBAction func editButtonPreesed(_ sender: UIBarButtonItem) {
        
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
            
        } else {
            
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        }

    }
}

extension PhotoshootList: UITableViewDataSource, ListTableViewCellDelegate {
    func checkBoxToggle(sender: ListTableViewCell) {
        
        if let selectedIndexPath = tableView.indexPath(for: sender) {
            
            toDoItems.itemsArray[selectedIndexPath.row].completed = !toDoItems.itemsArray[selectedIndexPath.row].completed
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            saveData()
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        
        cell.delegate = self
        cell.toDoItem = toDoItems.itemsArray[indexPath.row]
        

      
        // Return cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDoItems.itemsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()

        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let itemToMove = toDoItems.itemsArray[sourceIndexPath.row]
        toDoItems.itemsArray.remove(at: sourceIndexPath.row)
        toDoItems.itemsArray.insert(itemToMove, at: destinationIndexPath.row)
        saveData()
    }
    
    
}
