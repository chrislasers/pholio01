//
//  ToDoItem.swift
//  pholio01
//
//  Created by Chris  Ransom on 9/19/21.
//  Copyright © 2021 Chris Ransom. All rights reserved.
//

import Foundation

struct ToDoItem: Codable {
    
    var name: String
    var date: Date
    var notes: String
    var reminderSet: Bool
    var notificationID: String?
    var completed: Bool
}


