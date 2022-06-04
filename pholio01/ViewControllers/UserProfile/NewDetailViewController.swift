//
//  NewDetailViewController.swift
//  pholio01
//
//  Created by Chris  Ransom on 2/18/22.
//  Copyright © 2022 Chris Ransom. All rights reserved.
//

import Foundation

class NewDetailViewController : UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    

var image: UIImage!

override func viewDidLoad() {
    
    
    super.viewDidLoad()
    imageView.image = image
    navigationItem.title = "Photo"
    
    }
}
