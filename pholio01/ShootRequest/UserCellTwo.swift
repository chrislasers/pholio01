//
//  UserCell.swift
//  pholio01
//
//  Created by Chris  Ransom on 11/9/18.
//  Copyright © 2018 Chris Ransom. All rights reserved.
//

import UIKit
import Kingfisher


class UserCellTwo: UITableViewCell {
    
    
    var buttonFunc: (() -> (Void))!

   var buttonfunc: (() -> (Void))!

    
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var usertypeLabel: UILabel!
    
    
    @IBOutlet weak var propic: UIImageView!
    
    
     
    @IBOutlet weak var ff: UIButton!
    
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        buttonFunc()
    }
    
    
    @IBAction func viewProfle(_ sender: UIButton) {
        buttonfunc()
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()



        self.propic.layer.cornerRadius = self.propic.frame.size.height / 2;
        //self.propic.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        //self.propic.layer.borderWidth = 1.25
        self.propic.clipsToBounds = true
        propic.contentMode = .scaleAspectFill
        
        self.propic.layer.shadowColor   = UIColor.black.cgColor
        self.propic.layer.shadowOffset  = CGSize(width: 0.0, height: 5.0)
        self.propic.layer.shadowRadius  = 6.5
        self.propic.layer.shadowOpacity = 0.4
        clipsToBounds       = true



        setShadow()
        
     
        
        


    }


    private func setShadow() {
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 5.0)
        layer.shadowRadius  = 6.5
        layer.shadowOpacity = 0.4
        clipsToBounds       = true
        layer.masksToBounds = false
    }
    
    

    func setfunction(_ function: @escaping () -> Void) {

           self.buttonfunc = function

           button.backgroundColor = UIColor(r: 73, g: 103, b: 173)
           //signUpButton.setTitle("Sign Up", for: .normal)
           button.layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
           button.layer.borderWidth = 1.5
           button.layer.cornerRadius = 10
           button.setTitleColor(UIColor.white, for: .normal)
           //signUp.layer.shadowColor = UIColor.white.cgColor
           // signUp.layer.shadowRadius = 5
           button.layer.shadowOpacity = 0.5
           button.layer.shadowOffset = CGSize(width: 1, height: 1)


       }
    
    
    func setFunction(_ function: @escaping () -> Void) {
        
        self.buttonFunc = function
        
        
                  button.backgroundColor = UIColor(r: 73, g: 103, b: 173)
                  //signUpButton.setTitle("Sign Up", for: .normal)
                  button.layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
                  button.layer.borderWidth = 1.5
                  button.layer.cornerRadius = 10
                  button.setTitleColor(UIColor.white, for: .normal)
                  //signUp.layer.shadowColor = UIColor.white.cgColor
                  // signUp.layer.shadowRadius = 5
                  button.layer.shadowOpacity = 0.5
                  button.layer.shadowOffset = CGSize(width: 1, height: 1)
                  

        ff.backgroundColor = UIColor(r: 73, g: 103, b: 173)
        //signUpButton.setTitle("Sign Up", for: .normal)
        ff.layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
        ff.layer.borderWidth = 1.5
        ff.layer.cornerRadius = 10
        ff.setTitleColor(UIColor.white, for: .normal)
        //signUp.layer.shadowColor = UIColor.white.cgColor
        // signUp.layer.shadowRadius = 5
        ff.layer.shadowOpacity = 0.5
        ff.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        
    }
    
}
