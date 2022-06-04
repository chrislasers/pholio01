//
//  ListTableViewCell.swift
//  pholio01
//
//  Created by Chris  Ransom on 10/1/21.
//  Copyright © 2021 Chris Ransom. All rights reserved.
//

import UIKit


protocol ListTableViewCellDelegate {
    
    func checkBoxToggle(sender: ListTableViewCell)
    
    
}

class ListTableViewCell: UITableViewCell {
    
     var delegate: ListTableViewCellDelegate?
    var toDoItem: ToDoItem! {
        
        didSet{
            nameLabel.text = toDoItem.name
            checkBoxButton.isSelected = toDoItem.completed
        }
    }
    
    
    
    
    @IBOutlet weak var checkBoxButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBAction func checkToggled(_ sender: UIButton) {
        delegate?.checkBoxToggle(sender: self)
        
    }
    

}
