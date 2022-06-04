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
    
    
    
    
    var image: UIImage? {
        
        didSet {
            guard let image = image else { return }
            profileImage.image = image
        }
    }
    
    

        }
    
    
