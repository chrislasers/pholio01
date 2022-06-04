//
//  UploadimageCell.swift
//  pholio01
//
//  Created by Chris  Ransom on 6/2/18.
//  Copyright © 2018 Chris Ransom. All rights reserved.
//

import UIKit
import Haneke
import FirebaseUI
import SDWebImage
import Photos



class UploadimageCell: UICollectionViewCell {
    
        
        @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate : UploadimageCell?
    
    
    
        override func prepareForReuse() {
            super.prepareForReuse()
            
            self.imageView.image = nil
            
        }
    
    
    
    
    
    func fill(with object: Any) {
        if let image = object as? UIImage {
            imageView.image = image
            print("Image Noticed")
        } else if let urlString = object as? String, let imageURLs = URL(string: urlString) {
            imageView.hnk_setImage(from: imageURLs)
            print("URL Noticed")
        }
    }
    }

