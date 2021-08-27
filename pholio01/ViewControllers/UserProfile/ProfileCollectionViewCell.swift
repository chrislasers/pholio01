//
//  ProfileCollectionViewCell.swift
//  pholio01
//
//  Created by Chris  Ransom on 7/21/21.
//  Copyright © 2021 Chris Ransom. All rights reserved.
//


import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseStorage
import SwiftValidator
import Photos
import FirebaseFirestore
import Alamofire
import FirebaseCore
import SDWebImage


class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    
    var spot: Spot!
    var photo: Photo! {
        didSet {
            if let url = URL(string: self.photo.photoURL) {
                self.profileImage.sd_imageTransition = .fade
                self.profileImage.sd_imageTransition?.duration = 0.2
                self.profileImage.sd_setImage(with: url)
            } else {
                print("URL Didn't work \(self.photo.photoURL)")
                self.photo.loadImage(spot: self.spot) { (success) in
                    self.photo.saveData(spot: self.spot) { (success) in
                        print("image updated with URL \(self.photo.photoURL)")
                    }
                }
            }
        }
    }
    
    
    

        }
    
    
