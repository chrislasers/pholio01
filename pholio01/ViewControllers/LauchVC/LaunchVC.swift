//
//  LaunchVC.swift
//  pholio01
//
//  Created by Chris  Ransom on 2/19/20.
//  Copyright © 2020 Chris Ransom. All rights reserved.
//

import UIKit

class LaunchVC: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
       
       @IBOutlet weak var loginButton: UIButton!
       
       override func viewDidLoad() {
           super.viewDidLoad()
           // Do any additional setup after loading the view.
           
           setUpElements()
       }
       
      
    @IBAction func Profile(_ sender: Any) {
        
        
       // let layout = UICollectionViewFlowLayout()
//        let vc: SignUpVC = SignUpVC()
//        self.present(vc, animated: true, completion: nil)
        
      let vc = SignUpVC() //your view controller
        self.present(vc, animated: true, completion: nil)

//
    }
    
    
    
       
       func setUpElements() {
           
        //   Utilities.styleFilledButton(signUpButton)
           Utilities.styleHollowButton(loginButton)
           
       }
    


}
