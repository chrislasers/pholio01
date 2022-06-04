//
//  CourseCollectionView.swift
//  CollectionViewScrolling
//
//  Created by Manal  harbi on 08/09/1441 AH.
//  Copyright © 1441 ManaL. All rights reserved.
//

import UIKit

class CourseCollectionView: UICollectionViewCell {
    
     @IBOutlet weak var ImageViewCell: UIImageView!
    
    @IBOutlet weak var details: UILabel!
    
    
    
    
    var course : Course! {
        didSet {
            self.updateUI ()
        }
    }
    
    func updateUI() {
      
        if let course = course {
            ImageViewCell.image = course.imageCourse
            details.text = course.details
          
        } else {
            ImageViewCell.image = nil
          details.text = nil
            //colorView.backgroundColor = nil
        }
        
      
        ImageViewCell.layer.cornerRadius = 10.0
        ImageViewCell.layer.masksToBounds = true
        
    }
    
}
