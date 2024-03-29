//
//  User.swift
//  gameofchats
//
//  Created by Brian Voong on 6/29/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class Users {
    
    // defining our properties for our model layer
    var name: String?
    var age: Int?
    var hourlyrate: String?
    //    let imageNames: [String]
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var uid: String?
    
    
    var ageTextfield: String?
    var hrTextfield: String?
    var bioTextfield: String?
    
    
    
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    init(dictionary: [String: Any]) {
        // we'll initialize our user here
        
        self.ageTextfield = dictionary["ageTextfield"] as? String ?? ""
        self.hrTextfield = dictionary["hrTextfield"] as? String ?? ""
        self.bioTextfield = dictionary["bioTextfield"] as? String ?? ""
        
        self.age = dictionary["age"] as? Int
        self.hourlyrate = dictionary["hourlyrate"] as? String
        self.name = dictionary["fullName"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
    }
}
