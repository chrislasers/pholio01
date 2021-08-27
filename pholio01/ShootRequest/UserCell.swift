//
//  UserCell.swift
//  pholio01
//
//  Created by Chris  Ransom on 11/9/18.
//  Copyright © 2018 Chris Ransom. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    
    
    
    
    
    
   
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    

    
    
    
    var buttonFunc: (() -> (Void))!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        buttonFunc()
        
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.button.center.x - 10, y: button.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: button.center.x + 10, y: button.center.y))
        button.layer.add(animation, forKey: "position")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        
    }
    
    
    
    
    
    func setFunction(_ function: @escaping () -> Void) {
        
        self.buttonFunc = function
        
        self.button.clipsToBounds = true
        
        


        //button.backgroundColor = UIColor(r: 73, g: 103, b: 173)
        //signUpButton.setTitle("Sign Up", for: .normal)
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.white, for: .normal)
        //signUp.layer.shadowColor = UIColor.white.cgColor
        // signUp.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.75
        button.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        
        
    }
    
}
