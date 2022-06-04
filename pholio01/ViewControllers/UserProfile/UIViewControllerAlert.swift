//
//  UIViewControllerAlert.swift
//  pholio01
//
//  Created by Chris  Ransom on 10/1/21.
//  Copyright © 2021 Chris Ransom. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func oneButtonAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    
    
}
