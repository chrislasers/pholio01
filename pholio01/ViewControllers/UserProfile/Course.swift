//
//  Course.swift
//  CollectionViewScrolling
//
//  Created by Manal  harbi on 08/09/1441 AH.
//  Copyright © 1441 ManaL. All rights reserved.
//

import UIKit

class Course {
    
    var imageCourse : UIImage
    var details = ""
    
    
    init( imageCourse :UIImage , details : String  ) {
        self.imageCourse = imageCourse
        self.details = details
        
    }
    
    static func FetchCourse () -> [Course] {
        
        return [ Course(imageCourse: UIImage(named: "location1a" )!, details: "Gateway Arch Park") ,
                 Course(imageCourse: UIImage(named: "location2a" )!, details: "Kiener Plaza") ,
                 Course(imageCourse: UIImage(named: "location3a" )!, details: "City Garden") ,
                 Course(imageCourse: UIImage(named: "location4a" )!, details: "Tower Grove Park"),
                 Course(imageCourse: UIImage(named: "location8a" )!, details: "The Grove"),
                 Course(imageCourse: UIImage(named: "location5a" )!, details: "Art Hill"),
                 Course(imageCourse: UIImage(named: "location6a" )!, details: "Government Hill"),
                 Course(imageCourse: UIImage(named: "location7a" )!, details: "Shaw Park")
                 
        
 
        ]
        
    }
}



