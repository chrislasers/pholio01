//
// EnableBiometricViewController
// JournalApp
//
// Created by DevTechie Interactive on 2/2/19.
// Copyright © 2019 Devtechie. All rights reserved.
//

import UIKit

class EnableBiometricViewController: UIViewController {
    
    @IBOutlet weak var subheading: UILabel!
    @IBOutlet weak var faceOrTouchIDImageView: UIImageView!
    
    let biometricAuth = BiometricAuth()

    override func viewDidLoad() {
        super.viewDidLoad()

        var biometricType = ""
        faceOrTouchIDImageView.tintColor = UIColor.white
        switch biometricAuth.biometricType() {
        case .FaceID:
            biometricType = "FaceID."
            faceOrTouchIDImageView.image = #imageLiteral(resourceName: "faceid")
        default:
            biometricType = "TouchID."
            faceOrTouchIDImageView.image = #imageLiteral(resourceName: "touchid")
        }
        
        subheading.text = "Keep your journal safe without scarificing the convenience of quick access by enabling " + biometricType
    }
    
    @IBAction func skipButtonPressed(sender: UIButton) {
        performSegue(withIdentifier: "journal", sender: self)
    }
    
    @IBAction func enableBiometricPressed(sender: UIButton) {
        biometricAuth.authenticateUser { (message) in
            guard message == nil else {
                print(message!)
                return
            }
            
            UserDefaults.standard.set(true, forKey: NewConstants.kBiometricEnabled)
            UserDefaults.standard.synchronize()
            
            self.performSegue(withIdentifier: "journal", sender: self)
        }
    }

}
