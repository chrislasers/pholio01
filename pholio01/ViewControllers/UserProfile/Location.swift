//
//  Location.swift
//  pholio01
//
//  Created by Chris  Ransom on 10/16/21.
//  Copyright © 2021 Chris Ransom. All rights reserved.
//

import UIKit


class Location {
    
    var location : UIImage
    
    
    init( location :UIImage ) {
        
        self.location = location
        
    }
    
    static func FetchCourse () -> [Location] {
        
        return [
            Location(location: UIImage(named: "location1a" )!) ,
            Location(location: UIImage(named: "location2a" )!) ,
            Location(location: UIImage(named: "location3a" )!) ,
            Location(location: UIImage(named: "location4a" )!) ,
            Location(location: UIImage(named: "location5a" )!) ,
        ]
        
    }
    
    
    
    
    
    
}
