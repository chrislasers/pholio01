//
//  DetailViewController.swift
//  Photomanic
//
//  Created by Duc Tran on 5/21/17.
//  Copyright © 2017 Duc Tran. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController
{
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        navigationItem.title = "Photo"
    }
}














