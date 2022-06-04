//
//  SignInVC.swift
//  pholio01
//
//  Created by Chris  Ransom on 4/9/18.
//  Copyright © 2018 Chris Ransom. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseStorage
import SwiftValidator
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookLogin
import FacebookCore
import LBTAComponents
import JGProgressHUD
import MapKit
import CoreLocation
import GeoFire
import Pastel
import FirebaseMessaging
import FacebookShare
import FirebaseInstanceID
import UICircularProgressRing
import Lottie
import AuthenticationServices
import CryptoKit
import AppTrackingTransparency
import AdSupport

public enum Model : String {

//Simulator
case simulator     = "simulator/sandbox",

//iPod
iPod1              = "iPod 1",
iPod2              = "iPod 2",
iPod3              = "iPod 3",
iPod4              = "iPod 4",
iPod5              = "iPod 5",
iPod6              = "iPod 6",
iPod7              = "iPod 7",

//iPad
iPad2              = "iPad 2",
iPad3              = "iPad 3",
iPad4              = "iPad 4",
iPadAir            = "iPad Air ",
iPadAir2           = "iPad Air 2",
iPadAir3           = "iPad Air 3",
iPadAir4           = "iPad Air 4",
iPadAir5           = "iPad Air 5",
iPad5              = "iPad 5", //iPad 2017
iPad6              = "iPad 6", //iPad 2018
iPad7              = "iPad 7", //iPad 2019
iPad8              = "iPad 8", //iPad 2020
iPad9              = "iPad 9", //iPad 2021

//iPad Mini
iPadMini           = "iPad Mini",
iPadMini2          = "iPad Mini 2",
iPadMini3          = "iPad Mini 3",
iPadMini4          = "iPad Mini 4",
iPadMini5          = "iPad Mini 5",
iPadMini6          = "iPad Mini 6",

//iPad Pro
iPadPro9_7         = "iPad Pro 9.7\"",
iPadPro10_5        = "iPad Pro 10.5\"",
iPadPro11          = "iPad Pro 11\"",
iPadPro2_11        = "iPad Pro 11\" 2nd gen",
iPadPro3_11        = "iPad Pro 11\" 3rd gen",
iPadPro12_9        = "iPad Pro 12.9\"",
iPadPro2_12_9      = "iPad Pro 2 12.9\"",
iPadPro3_12_9      = "iPad Pro 3 12.9\"",
iPadPro4_12_9      = "iPad Pro 4 12.9\"",
iPadPro5_12_9      = "iPad Pro 5 12.9\"",

//iPhone
iPhone4            = "iPhone 4",
iPhone4S           = "iPhone 4S",
iPhone5            = "iPhone 5",
iPhone5S           = "iPhone 5S",
iPhone5C           = "iPhone 5C",
iPhone6            = "iPhone 6",
iPhone6Plus        = "iPhone 6 Plus",
iPhone6S           = "iPhone 6S",
iPhone6SPlus       = "iPhone 6S Plus",
iPhoneSE           = "iPhone SE",
iPhone7            = "iPhone 7",
iPhone7Plus        = "iPhone 7 Plus",
iPhone8            = "iPhone 8",
iPhone8Plus        = "iPhone 8 Plus",
iPhoneX            = "iPhone X",
iPhoneXS           = "iPhone XS",
iPhoneXSMax        = "iPhone XS Max",
iPhoneXR           = "iPhone XR",
iPhone11           = "iPhone 11",
iPhone11Pro        = "iPhone 11 Pro",
iPhone11ProMax     = "iPhone 11 Pro Max",
iPhoneSE2          = "iPhone SE 2nd gen",
iPhone12Mini       = "iPhone 12 Mini",
iPhone12           = "iPhone 12",
iPhone12Pro        = "iPhone 12 Pro",
iPhone12ProMax     = "iPhone 12 Pro Max",
iPhone13Mini       = "iPhone 13 Mini",
iPhone13           = "iPhone 13",
iPhone13Pro        = "iPhone 13 Pro",
iPhone13ProMax     = "iPhone 13 Pro Max",
iPhoneSE3          = "iPhone SE 3nd gen",

// Apple Watch
AppleWatch1         = "Apple Watch 1gen",
AppleWatchS1        = "Apple Watch Series 1",
AppleWatchS2        = "Apple Watch Series 2",
AppleWatchS3        = "Apple Watch Series 3",
AppleWatchS4        = "Apple Watch Series 4",
AppleWatchS5        = "Apple Watch Series 5",
AppleWatchSE        = "Apple Watch Special Edition",
AppleWatchS6        = "Apple Watch Series 6",
AppleWatchS7        = "Apple Watch Series 7",

//Apple TV
AppleTV1           = "Apple TV 1gen",
AppleTV2           = "Apple TV 2gen",
AppleTV3           = "Apple TV 3gen",
AppleTV4           = "Apple TV 4gen",
AppleTV_4K         = "Apple TV 4K",
AppleTV2_4K        = "Apple TV 4K 2gen",

unrecognized       = "?unrecognized?"
}




class SignInVC: UIViewController, UITextFieldDelegate, MessagingDelegate, ValidationDelegate, CLLocationManagerDelegate, UICircularProgressRingDelegate {
    func didFinishProgress(for ring: UICircularProgressRing) {
         print("Finish Progress!")
    }
    
    func didPauseProgress(for ring: UICircularProgressRing) {
         print("Finish Pause!")
    }
    
    func didContinueProgress(for ring: UICircularProgressRing) {
         print("FinishContinue Progress!")
    }
    
    func didUpdateProgressValue(for ring: UICircularProgressRing, to newValue: CGFloat) {
         print("Finish Update Progress Value!")
    }
    
    func willDisplayLabel(for ring: UICircularProgressRing, _ label: UILabel) {
         print("Finish Display Label Value!")
    }
    
    
    
    func validationSuccessful() {
        
        validator.registerField(email, errorLabel: emailValid, rules: [RequiredRule(), EmailRule(message: "Invalid email")])
        
        validator.registerField(password, errorLabel: passwordValid, rules: [RequiredRule(), PasswordRule(message: "Must be 8 characters. One uppercase. One Lowercase. One number.")])
       
        print("Validation Success!")
        
        
        
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            
            print("Validation Error!")
            
            
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 0.2
            }
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    var ref : DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    let validator = Validator()
    let biometricAuth = BiometricAuth()
    let Model: String = "Model"
    

    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    
    @IBOutlet weak var biometricButton: UIButton!
    
    
    
    @IBOutlet weak var signInPressed: UIButton!
    
    
    @IBOutlet weak var emailValid: UILabel!
    
    @IBOutlet weak var passwordValid: UILabel!
    
    @IBOutlet weak var fbValid: UILabel!
    
    @IBOutlet weak var signUp: UIButton!
    
    @IBOutlet weak var signIn: UIButton!
    
    @IBOutlet var forgetPassword: UIButton!
    

    @IBOutlet var popOver: UIView!
    @IBOutlet var newLogo: UIImageView!
    
    
    @IBOutlet var Logo: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
       ///Login With FaceID
//
//        let myButton = UIButton(frame: CGRect(x: 165, y: 743, width: 50, height: 50))
//          let img = UIImage(named: "faceid")
//        myButton.setImage(img , for: .normal)
//           myButton.addTarget(self, action: #selector(loginWithBiometricAuth), for: .touchUpInside)
//           self.view.addSubview(myButton)
        
        func requestPermission() {
           if #available(iOS 14, *) {
               ATTrackingManager.requestTrackingAuthorization { status in
                   switch status {
                   case .authorized:
                       // Tracking authorization dialog was shown
                       // and we are authorized
                       print("Authorized")
                       
                       // Now that we are authorized we can get the IDFA
                       print(ASIdentifierManager.shared().advertisingIdentifier)
                   case .denied:
                       // Tracking authorization dialog was
                       // shown and permission is denied
                       print("Denied")
                   case .notDetermined:
                       // Tracking authorization dialog has not been shown
                       print("Not Determined")
                   case .restricted:
                       print("Restricted")
                   @unknown default:
                       print("Unknown")
                   }
               }
           } else {
               // Fallback on earlier versions
           }
       }
      
        
         ref = Database.database().reference()
        
        //performExistingAccountSetupFlows()
        

        //setupSignInButton()

        
        var signInWithFbButton: UIButton {
            
            // Add a custom login button to your app
            let myLoginButton = UIButton(type: .custom)
            myLoginButton.backgroundColor = UIColor(r: 73, g: 103, b: 173)
            myLoginButton.frame = CGRect(x: 50, y: 520, width: view.frame.width - 105, height: 47)
            myLoginButton.setTitle("Login with Facebook", for: .normal)
            myLoginButton.setTitleColor(UIColor.white, for: .normal)
            myLoginButton.layer.cornerRadius = 7
            myLoginButton.layer.borderColor = UIColor.white.cgColor
            myLoginButton.layer.borderWidth = 1.0
            myLoginButton.setImage(#imageLiteral(resourceName: "flogo_RGB_HEX-144").withRenderingMode(.automatic), for: .normal)
            myLoginButton.tintColor = .white
            myLoginButton.contentMode = .scaleAspectFill
            myLoginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize:  16)
            myLoginButton.layer.masksToBounds = true
            // Handle clicks on the button
            myLoginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
           
            _ = UIDevice().type.rawValue
            
            switch UIDevice().type {
                
                
            case .iPhoneSE:
                 myLoginButton.frame = CGRect(x: 40, y: 525, width: 253, height: 47)
                
            case .iPhone5S:
                myLoginButton.frame = CGRect(x: 40, y: 525, width: 253, height: 47)
                
            case .iPhone6, .iPhone7, .iPhone6S,.iPhone8:
                myLoginButton.frame = CGRect(x: 50, y: 620, width: view.frame.width - 105, height: 47)
                
            case .iPhone6SPlus:
                myLoginButton.frame = CGRect(x: 50, y: 630, width: view.frame.width - 105, height: 47)

            case .iPhone7Plus:
                myLoginButton.frame = CGRect(x: 50, y: 630, width: view.frame.width - 105, height: 47)
                
            case .iPhone8Plus:
                myLoginButton.frame = CGRect(x: 50, y: 6255, width: view.frame.width - 98, height: 47)
                
            case .iPhoneX:
                myLoginButton.frame = CGRect(x: 50, y: 790, width: view.frame.width - 105, height: 47)
                
            case .iPhoneXS, .iPhoneXR:
                myLoginButton.frame = CGRect(x: 50, y: 700, width: view.frame.width - 98, height: 47)
                
            case .iPhoneXSMax:
                myLoginButton.frame = CGRect(x: 50, y: 700, width: view.frame.width - 100, height: 47)
                
            case .iPhone11:
                myLoginButton.frame = CGRect(x: 50, y: 790, width: view.frame.width - 105, height: 47)
                
            case .iPhone11Pro:
                myLoginButton.frame = CGRect(x: 50, y: 705, width: view.frame.width - 105, height: 47)
                
            case .iPhone11ProMax:
                myLoginButton.frame = CGRect(x: 50, y: 796, width: view.frame.width - 105, height: 47)
            
            case .iPhone12:
                myLoginButton.frame = CGRect(x: 50, y: 730, width: view.frame.width - 105, height: 47)
                
            case .iPhone12Pro:
                myLoginButton.frame = CGRect(x: 50, y: 730, width: view.frame.width - 105, height: 47)
                
            case .iPhone12ProMax:
                myLoginButton.frame = CGRect(x: 50, y: 815, width: view.frame.width - 105, height: 47)
                
            case .iPhone12Mini:
                
                myLoginButton.frame = CGRect(x: 50, y: 700, width: view.frame.width - 98, height: 47)

            default:
                print(UIDevice().type.rawValue + " not supported by this app");

            }

        
            return myLoginButton
        }
        // Add the FACEBOOK button to the view
        //view.addSubview(signInWithFbButton)

        switch UIDevice().type {
            
        case .iPad9:
            
            newLogo.frame = CGRect(x: 123, y: 77, width: 135, height: 135)

            Logo.frame = CGRect(x: 90, y: 44, width: 200, height: 200)

        case .iPadAir4:
            
            
            newLogo.frame = CGRect(x: 123, y: 77, width: 135, height: 135)
            
            Logo.frame = CGRect(x: 90, y: 44, width: 200, height: 200)
            
        case .iPadPro9_7:
            
            
            newLogo.frame = CGRect(x: 123, y: 77, width: 135, height: 135)
            
            Logo.frame = CGRect(x: 90, y: 44, width: 200, height: 200)
            
        case .iPadPro3_11:
            newLogo.frame = CGRect(x: 123, y: 77, width: 135, height: 135)
            
            Logo.frame = CGRect(x: 90, y: 44, width: 200, height: 200)

        case .iPadPro5_12_9:
            
            newLogo.frame = CGRect(x: 123, y: 77, width: 135, height: 135)
            
            Logo.frame = CGRect(x: 90, y: 44, width: 200, height: 200)

        case .iPadMini6:
            
            newLogo.frame = CGRect(x: 123, y: 77, width: 135, height: 135)
            
            Logo.frame = CGRect(x: 90, y: 44, width: 200, height: 200)

    
        case .iPhoneSE:
            
            newLogo.frame = CGRect(x: 123, y: 77, width: 135, height: 135)

            Logo.frame = CGRect(x: 90, y: 44, width: 200, height: 200)

            
        case .iPhoneSE2:
            
            newLogo.frame = CGRect(x: 123, y: 77, width: 135, height: 135)

            Logo.frame = CGRect(x: 90, y: 44, width: 200, height: 200)


        case .iPhone5S:

            newLogo.frame = CGRect(x: 115, y: 97, width: 100, height: 100)

            Logo.frame = CGRect(x: 83, y: 64, width: 165, height: 165)

        case .iPhone7Plus:

            newLogo.frame = CGRect(x: 136, y: 97, width: 145, height: 145)

            Logo.frame = CGRect(x: 103, y: 64, width: 210, height: 210)
            
        case .iPhone8:

            newLogo.frame = CGRect(x: 123, y: 97, width: 135, height: 135)

            Logo.frame = CGRect(x: 90, y: 64, width: 200, height: 200)

        case .iPhone8Plus:

            newLogo.frame = CGRect(x: 136, y: 97, width: 145, height: 145)

            Logo.frame = CGRect(x: 103, y: 64, width: 210, height: 210)

        case .iPhoneXR:

            newLogo.frame = CGRect(x: 136, y: 97, width: 145, height: 145)

            Logo.frame = CGRect(x: 103, y: 64, width: 210, height: 210)


        case .iPhoneXS:
            
            newLogo.frame = CGRect(x: 116, y: 137, width: 145, height: 145)

            Logo.frame = CGRect(x: 83, y: 104, width: 210, height: 210)
            
        case .iPhoneXSMax:

            newLogo.frame = CGRect(x: 136, y: 97, width: 145, height: 145)

            Logo.frame = CGRect(x: 103, y: 64, width: 210, height: 210)
            
        case .iPhone11Pro:
            
            newLogo.frame = CGRect(x: 103, y: 120, width: 170, height: 170)

            Logo.frame = CGRect(x: 63, y: 80, width: 250, height: 250)
            
        case .iPhone11ProMax:
            newLogo.frame = CGRect(x: 100, y: 137, width: 220, height: 220)

            Logo.frame = CGRect(x: 44, y: 82, width: 330, height: 330)
      
        case .iPhone12:
            newLogo.frame = CGRect(x: 110, y: 140, width: 170, height: 170)

            Logo.frame = CGRect(x: 70, y: 100, width: 250, height: 250)
            
        case .iPhone12Pro:
            
            newLogo.frame = CGRect(x: 110, y: 140, width: 170, height: 170)

            Logo.frame = CGRect(x: 70, y: 100, width: 250, height: 250)
            
        case .iPhone12ProMax:
            
            newLogo.frame = CGRect(x: 110, y: 147, width: 220, height: 220)

            Logo.frame = CGRect(x: 54, y: 94, width: 330, height: 330)
            
        case .iPhone12Mini:
            
            newLogo.frame = CGRect(x: 116, y: 137, width: 145, height: 145)

            Logo.frame = CGRect(x: 83, y: 104, width: 210, height: 210)
            
        case .iPhone13Mini:

            newLogo.frame = CGRect(x: 110, y: 140, width: 170, height: 170)

            Logo.frame = CGRect(x: 70, y: 100, width: 250, height: 250)
            
        case .iPod7:
            
            newLogo.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            
            Logo.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            
            

        default:
            
            newLogo.frame = CGRect(x: 123, y: 77, width: 135, height: 135)
            
            Logo.frame = CGRect(x: 90, y: 44, width: 200, height: 200)

        }

    
        email.keyboardType = .emailAddress
        //email.placeholder = "Email Address"
        self.view.addSubview(email)
        
        // password.placeholder = "Password"
        self.view.addSubview(password)


          self.Logo.layer.cornerRadius = self.Logo.frame.size.height / 2
        self.newLogo.layer.cornerRadius = self.Logo.frame.size.height / 2

         self.Logo.layer.shadowColor = UIColor.black.cgColor
         self.Logo.layer.shadowRadius = 9
         self.Logo.layer.shadowOpacity = 1.5
        self.Logo.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        
        
        
        signUp.backgroundColor = UIColor.orange
        signUp.setTitle("Sign Up", for: .normal)
        signUp.layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
        signUp.layer.borderWidth = 1.5
        signUp.layer.cornerRadius = 4
        signUp.setTitleColor(UIColor.white, for: .normal)
        //signUp.layer.shadowColor = UIColor.white.cgColor
       // signUp.layer.shadowRadius = 5
        signUp.layer.shadowOpacity = 0.4
        signUp.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        
        signIn.backgroundColor = UIColor.clear
        
        signIn.layer.borderColor = UIColor.white.withAlphaComponent(0.20).cgColor
        signIn.layer.borderWidth = 1.5
        signIn.layer.cornerRadius = 4

        signIn.setTitleColor(UIColor.white, for: .normal)
        //signIn.layer.shadowColor = UIColor.white.cgColor
        //signIn.layer.shadowRadius = 12
        signIn.layer.shadowOpacity = 0.4
        signIn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        
        signUp.addTarget(self, action: #selector(setButtonSelected(button:)), for: .touchDown);
        signUp.addTarget(self, action: #selector(setButtonUnselected(button:)), for: .touchUpInside)
        
        configureTextFields()
        
        
        emailValid.isHidden = true
        passwordValid.isHidden = true
        fbValid.isHidden = true
        
        
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("here")
            // clear error label
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 0.2
                
            }
        }, error:{ (validationError) -> Void in
            print("error")
            validationError.errorLabel?.isHidden = false
            validationError.errorLabel?.text = validationError.errorMessage
            if let textField = validationError.field as? UITextField {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
            }
        })
        
    
        validator.registerField(email, errorLabel: emailValid, rules: [RequiredRule(), EmailRule(message: "Invalid Email")])
        
        validator.registerField(password, errorLabel: passwordValid, rules: [RequiredRule(), PasswordRule(message: "Invalid Password")])
        
        
        
        signInPressed.addTarget(self, action: #selector(signinPRESSED), for: .touchUpInside)
        
        signInPressed(enabled: false)
        
        
        email.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        password.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        email.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidBegin)
        email.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
        email.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEndOnExit )
        
        password.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidBegin)
        password.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
        password.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEndOnExit )
        
        
        
        
        
        //Listens For Keyboard Events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    
    @objc func keyboardWillChange(notification: Notification) {
        
        guard ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -157
        } else {
            
            view.frame.origin.y = 0
            
        }
    }
    
    var didSetupWhiteTintColorForClearTextFieldButton = false
    var didsetupWhiteTintColorForClearTextFieldButton = false
    
    
    
    private func setupTintColorForTextFieldClearButtonIfNeeded() {
        // Do it once only
        if didSetupWhiteTintColorForClearTextFieldButton { return }
        
        guard let button = email.value(forKey: "_clearButton") as? UIButton else { return }
        guard let icon = button.image(for: .normal)?.withRenderingMode(.alwaysTemplate) else { return }
        button.setImage(icon, for: .normal)
        button.tintColor = .white
        didSetupWhiteTintColorForClearTextFieldButton = true
    }
    
    private func setUpTintColorForTextFieldClearButtonIfNeeded() {
        // Do it once only
        if didsetupWhiteTintColorForClearTextFieldButton { return }
        
        guard let button = password.value(forKey: "_clearButton") as? UIButton else { return }
        guard let icon = button.image(for: .normal)?.withRenderingMode(.alwaysTemplate) else { return }
        button.setImage(icon, for: .normal)
        button.tintColor = .white
        didSetupWhiteTintColorForClearTextFieldButton = true
    }
    
    func setupSignInButton() {
        
        let signInButton = ASAuthorizationAppleIDButton()
        signInButton.addTarget(self, action: #selector(handleSignWithAppleTapped), for: .touchUpInside)
       
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signInButton)
        
        switch UIDevice().type {
            
        case .iPad9:
            
            NSLayoutConstraint.activate([
                signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -15),
                       signInButton.heightAnchor.constraint(equalToConstant: 45),
                       signInButton.widthAnchor.constraint(equalToConstant: 280)
                   ])
            
        case .iPadAir5:
            
            NSLayoutConstraint.activate([
                signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -15),
                       signInButton.heightAnchor.constraint(equalToConstant: 45),
                       signInButton.widthAnchor.constraint(equalToConstant: 280)
                   ])
            
        case .iPadPro9_7:
            
            NSLayoutConstraint.activate([
                signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -15),
                       signInButton.heightAnchor.constraint(equalToConstant: 45),
                       signInButton.widthAnchor.constraint(equalToConstant: 280)
                   ])
            
        case .iPadPro3_11:
            
            
            NSLayoutConstraint.activate([
                signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -15),
                       signInButton.heightAnchor.constraint(equalToConstant: 45),
                       signInButton.widthAnchor.constraint(equalToConstant: 280)
                   ])
            
        case .iPadPro5_12_9:
            
            
            NSLayoutConstraint.activate([
                signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -15),
                       signInButton.heightAnchor.constraint(equalToConstant: 45),
                       signInButton.widthAnchor.constraint(equalToConstant: 280)
                   ])
            
        case .iPadMini6:

            
            NSLayoutConstraint.activate([
                signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -15),
                       signInButton.heightAnchor.constraint(equalToConstant: 45),
                       signInButton.widthAnchor.constraint(equalToConstant: 280)
                   ])
            
        case .iPhone6S:
            
            
            NSLayoutConstraint.activate([
                signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -15),
                       signInButton.heightAnchor.constraint(equalToConstant: 45),
                       signInButton.widthAnchor.constraint(equalToConstant: 280)
                   ])


            
        case .iPhone8:

            NSLayoutConstraint.activate([
                signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -15),
                       signInButton.heightAnchor.constraint(equalToConstant: 45),
                       signInButton.widthAnchor.constraint(equalToConstant: 280)
                   ])
            
        case .iPod7:
            
            
            NSLayoutConstraint.activate([
                signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -15),
                       signInButton.heightAnchor.constraint(equalToConstant: 45),
                       signInButton.widthAnchor.constraint(equalToConstant: 280)
                   ])

            
        case .iPhoneSE3:
            
            NSLayoutConstraint.activate([
                signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -30),
                       signInButton.heightAnchor.constraint(equalToConstant: 45),
                       signInButton.widthAnchor.constraint(equalToConstant: 280)
                   ])

        default:
            
            
            NSLayoutConstraint.activate([
                signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -70),
                       signInButton.heightAnchor.constraint(equalToConstant: 45),
                       signInButton.widthAnchor.constraint(equalToConstant: 280)
                   ])
        }

        
      
    }
    
    @objc func handleSignWithAppleTapped() {
        performSignIn()
    }

    
    func performSignIn() {
        
        let request = createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        
        return request
    }
    
    private func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?

    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }

    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        
        let tf = CustomTextField(padding: 24, height: 44)
        
        tf.layer.cornerRadius =  tf.height / 2
        //tf.placeholder = "Enter Username"
        tf.backgroundColor = .white
        
        email.keyboardType = .emailAddress
        email.placeholder = "Email"
        
        let password: CustomTextField = {
            let tf = CustomTextField(padding: 24, height: 44)
            tf.placeholder = "Password"
            tf.isSecureTextEntry = true
            tf.backgroundColor = .white
            return tf
        }()
        

        
        switch UIDevice().type {
        
        case .iPhone5S:
            
            email.frame = CGRect(x: 51, y: 250, width: 220, height: 45)
            
            password.frame = CGRect(x: 238, y: 383, width: 33, height: 16)
            
            
            emailValid.frame = CGRect(x: 238, y: 359, width: 33, height: 16)
            
            passwordValid.frame = CGRect(x: 238, y: 436, width: 33, height: 16)
            
            
            forgetPassword.frame = CGRect(x: 133, y: 446, width: 108, height: 27)
            
            
            signIn.frame = CGRect(x: 51, y: 495, width: 220, height: 45)
            
            signUp.frame = CGRect(x: 51, y: 548, width: 220, height: 45)
            
        case .iPhoneX:
            
            
            email.frame = CGRect(x: 51, y: 330, width: 275, height: 45)
            
            password.frame = CGRect(x: 51, y: 407, width: 275, height: 45)
            
            
            emailValid.frame = CGRect(x: 293, y: 383, width: 33, height: 16)
            
            passwordValid.frame = CGRect(x: 238, y: 4462, width: 33, height: 16)
            
            
            forgetPassword.frame = CGRect(x: 133, y: 446, width: 108, height: 27)
            
            
            signIn.frame = CGRect(x: 51, y: 519, width: 275, height: 45)
            
            signUp.frame = CGRect(x: 51, y: 570, width: 275, height: 45)
           
            
        default: break

    }
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTintColorForTextFieldClearButtonIfNeeded()
        setUpTintColorForTextFieldClearButtonIfNeeded()
        
        
        switch UIDevice().type {
            
            
        case .iPhoneSE:
            
            
            email.frame = CGRect(x: 42, y: 241, width: 250, height: 45)
            
            password.frame = CGRect(x: 42, y: 318, width: 250, height: 45)
            
            
            emailValid.frame = CGRect(x: 305, y: 359, width: 33, height: 16)
            
            passwordValid.frame = CGRect(x: 305, y: 436, width: 33, height: 16)
            
            
            forgetPassword.frame = CGRect(x: 115, y: 365, width: 108, height: 27)
            
            
            signIn.frame = CGRect(x: 42, y: 410, width: 250, height: 45)
            
            signUp.frame = CGRect(x: 42, y: 460, width: 250, height: 45)
        
        case .iPhone5S:
            
            email.frame = CGRect(x: 42, y: 241, width: 250, height: 45)
            
            password.frame = CGRect(x: 42, y: 318, width: 250, height: 45)
            
            
            emailValid.frame = CGRect(x: 305, y: 359, width: 33, height: 16)
            
            passwordValid.frame = CGRect(x: 305, y: 436, width: 33, height: 16)
            
            
            forgetPassword.frame = CGRect(x: 115, y: 365, width: 108, height: 27)
            
            
            signIn.frame = CGRect(x: 42, y: 410, width: 250, height: 45)
            
            signUp.frame = CGRect(x: 42, y: 460, width: 250, height: 45)
            
        
        case .iPhone6:
            
            email.frame = CGRect(x: 51, y: 306, width: 275, height: 45)
            
            password.frame = CGRect(x: 51, y: 383, width: 275, height: 45)
            
            
            emailValid.frame = CGRect(x: 293, y: 359, width: 33, height: 16)
            
            passwordValid.frame = CGRect(x: 293, y: 436, width: 33, height: 16)
            
            
            forgetPassword.frame = CGRect(x: 133, y: 446, width: 108, height: 27)
            
            
            signIn.frame = CGRect(x: 51, y: 495, width: 275, height: 45)
            
            signUp.frame = CGRect(x: 51, y: 548, width: 275, height: 45)
            
            
        case .iPhone6Plus:
            
            email.frame = CGRect(x: 51, y: 306, width: 314, height: 45)
            
            password.frame = CGRect(x: 51, y: 383, width: 314, height: 45)
            
            
            emailValid.frame = CGRect(x: 332, y: 359, width: 33, height: 16)
            
            passwordValid.frame = CGRect(x: 332, y: 436, width: 33, height: 16)
            
            
            forgetPassword.frame = CGRect(x: 155, y: 440, width: 108, height: 27)
            
            
            signIn.frame = CGRect(x: 51, y: 495, width: 314, height: 45)
            
            signUp.frame = CGRect(x: 51, y: 548, width: 314, height: 45)
            
            newLogo.frame = CGRect(x: 136, y: 97, width: 145, height: 145)
            
            Logo.frame = CGRect(x: 103, y: 64, width: 210, height: 210)
          
        case .iPhone6S:
            
            email.frame = CGRect(x: 51, y: 306, width: 275, height: 45)
            
            password.frame = CGRect(x: 51, y: 383, width: 275, height: 45)
            
            
            emailValid.frame = CGRect(x: 293, y: 359, width: 33, height: 16)
            
            passwordValid.frame = CGRect(x: 293, y: 436, width: 33, height: 16)
            
            
            forgetPassword.frame = CGRect(x: 133, y: 446, width: 108, height: 27)
            
            
            signIn.frame = CGRect(x: 51, y: 495, width: 275, height: 45)
            
            signUp.frame = CGRect(x: 51, y: 548, width: 275, height: 45)
            
            
            newLogo.frame = CGRect(x: 112, y: 97, width: 145, height: 145)
            
            Logo.frame = CGRect(x: 80, y: 64, width: 210, height: 210)
            
           
         case .iPhone6SPlus:
            
            email.frame = CGRect(x: 51, y: 306, width: 314, height: 45)
            
            password.frame = CGRect(x: 51, y: 383, width: 314, height: 45)
            
            
            emailValid.frame = CGRect(x: 332, y: 359, width: 33, height: 16)
            
            passwordValid.frame = CGRect(x: 332, y: 436, width: 33, height: 16)
            
            
            forgetPassword.frame = CGRect(x: 155, y: 440, width: 108, height: 27)
            
            
            signIn.frame = CGRect(x: 51, y: 495, width: 314, height: 45)
            
            signUp.frame = CGRect(x: 51, y: 548, width: 314, height: 45)
            
            newLogo.frame = CGRect(x: 127, y: 97, width: 145, height: 145)
            
            Logo.frame = CGRect(x: 95, y: 64, width: 210, height: 210)
          
        case .iPhone7:
            
            email.frame = CGRect(x: 51, y: 306, width: 275, height: 45)
            
            password.frame = CGRect(x: 51, y: 383, width: 275, height: 45)
            
            
            emailValid.frame = CGRect(x: 293, y: 359, width: 33, height: 16)
            
            passwordValid.frame = CGRect(x: 293, y: 436, width: 33, height: 16)
            
            
            forgetPassword.frame = CGRect(x: 133, y: 446, width: 108, height: 27)
            
            
            signIn.frame = CGRect(x: 51, y: 495, width: 275, height: 45)
            
            signUp.frame = CGRect(x: 51, y: 548, width: 275, height: 45)
            
            
            newLogo.frame = CGRect(x: 112, y: 97, width: 145, height: 145)
            
            Logo.frame = CGRect(x: 80, y: 64, width: 210, height: 210)
       
        case .iPhone7Plus:
            
            
            email.frame = CGRect(x: 51, y: 306, width: 314, height: 45)
            
            password.frame = CGRect(x: 51, y: 383, width: 314, height: 45)
            
            
            emailValid.frame = CGRect(x: 332, y: 359, width: 33, height: 16)
            
            passwordValid.frame = CGRect(x: 332, y: 436, width: 33, height: 16)
            
            
            forgetPassword.frame = CGRect(x: 155, y: 440, width: 108, height: 27)
            
            
            signIn.frame = CGRect(x: 51, y: 495, width: 314, height: 45)
            
            signUp.frame = CGRect(x: 51, y: 548, width: 314, height: 45)
            
        newLogo.frame = CGRect(x: 136, y: 97, width: 145, height: 145)
    
        Logo.frame = CGRect(x: 103, y: 64, width: 210, height: 210)
       
            
        case .iPhone8:
            
            email.frame = CGRect(x: 51, y: 306, width: 275, height: 45)
            
            password.frame = CGRect(x: 51, y: 383, width: 275, height: 45)
            
            
            emailValid.frame = CGRect(x: 293, y: 359, width: 33, height: 16)
            
            passwordValid.frame = CGRect(x: 293, y: 436, width: 33, height: 16)
            
            
            forgetPassword.frame = CGRect(x: 133, y: 446, width: 108, height: 27)
            
            
            signIn.frame = CGRect(x: 51, y: 495, width: 275, height: 45)
            
            signUp.frame = CGRect(x: 51, y: 548, width: 275, height: 45)
          
        case .iPhone8Plus:
            
            email.frame = CGRect(x: 51, y: 306, width: 314, height: 45)
            
            password.frame = CGRect(x: 51, y: 383, width: 314, height: 45)
            
            
            emailValid.frame = CGRect(x: 332, y: 359, width: 33, height: 16)
            
            passwordValid.frame = CGRect(x: 332, y: 436, width: 33, height: 16)
            
            
            forgetPassword.frame = CGRect(x: 155, y: 440, width: 108, height: 27)
            
            
            signIn.frame = CGRect(x: 51, y: 495, width: 314, height: 45)
            
            signUp.frame = CGRect(x: 51, y: 548, width: 314, height: 45)
           
            
        case .iPhoneX:
            
            
            email.frame = CGRect(x: 51, y: 330, width: 275, height: 45)
            
            password.frame = CGRect(x: 51, y: 407, width: 275, height: 45)
            
            
            emailValid.frame = CGRect(x: 293, y: 383, width: 33, height: 16)
            
            passwordValid.frame = CGRect(x: 238, y: 436, width: 33, height: 16)
            
            
            forgetPassword.frame = CGRect(x: 133, y: 450, width: 108, height: 27)
            
            
            signIn.frame = CGRect(x: 51, y: 519, width: 275, height: 45)
            
            signUp.frame = CGRect(x: 51, y: 570, width: 275, height: 45)
         
        case .iPhoneXS:
            
            
            
            email.frame = CGRect(x: 51, y: 380, width: 275, height: 45)
            
            password.frame = CGRect(x: 51, y: 457, width: 275, height: 45)
            
            
            emailValid.frame = CGRect(x: 293, y: 433, width: 33, height: 16)
            
            passwordValid.frame = CGRect(x: 293, y: 510, width: 33, height: 16)
            
            
            forgetPassword.frame = CGRect(x: 133, y: 520, width: 108, height: 27)
            
            
            signIn.frame = CGRect(x: 51, y: 568, width: 275, height: 45)
            
            signUp.frame = CGRect(x: 51, y: 622, width: 275, height: 45)
         
        case .iPhoneXR:
            
            
            email.frame = CGRect(x: 51, y: 330, width: 314, height: 45)
            
            password.frame = CGRect(x: 51, y: 407, width: 314, height: 45)
            
            
            emailValid.frame = CGRect(x: 332, y: 383, width: 33, height: 16)
            
            passwordValid.frame = CGRect(x: 332, y: 460, width: 33, height: 16)
            
            
            forgetPassword.frame = CGRect(x: 155, y: 460, width: 108, height: 27)
            
            
            signIn.frame = CGRect(x: 51, y: 519, width: 314, height: 45)
            
            signUp.frame = CGRect(x: 51, y: 572, width: 314, height: 45)
           
            
        case .iPhoneXSMax:
            
            
            email.frame = CGRect(x: 51, y: 330, width: 314, height: 45)
            
            password.frame = CGRect(x: 51, y: 407, width: 314, height: 45)
            
            
            emailValid.frame = CGRect(x: 332, y: 383, width: 33, height: 16)
            
            passwordValid.frame = CGRect(x: 332, y: 460, width: 33, height: 16)
            
            
            forgetPassword.frame = CGRect(x: 155, y: 460, width: 108, height: 27)
            
            
            signIn.frame = CGRect(x: 51, y: 519, width: 314, height: 45)
            
            signUp.frame = CGRect(x: 51, y: 572, width: 314, height: 45)
           
        default: break
        }
    }
    
    
    @objc func setButtonSelected(button : UIButton) {
        
        signUp.backgroundColor = UIColor.orange
        
        signUp.setTitle("Sign Up", for: .normal)
        signUp.setTitleColor(UIColor.white, for: .normal)

        
        //signUp.layer.borderWidth = 1.6
        
        //signUp.layer.borderColor = UIColor.white.cgColor
         
        
        signUp.layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
        signUp.layer.borderWidth = 1.5
        signUp.layer.cornerRadius = 4
        
        
        //signUp.layer.cornerRadius = signUp.frame.height / 2
        signUp.layer.shadowColor = UIColor.white.cgColor
        signUp.layer.shadowRadius = 2
        signUp.layer.shadowOpacity = 0.2
        signUp.layer.shadowOffset = CGSize(width: 0, height: 0)    }
    
    @objc func setButtonUnselected(button : UIButton) {
        
        signUp.setTitle("Sign Up", for: .normal)
        
        signUp.backgroundColor = UIColor.orange
        
       // signUp.layer.borderWidth = 1.6
        
       // signUp.layer.borderColor = UIColor.white.cgColor
        
       // signUp.layer.cornerRadius = signUp.frame.height / 2
        
        signUp.layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
        signUp.layer.borderWidth = 1.5
        signUp.layer.cornerRadius = 4
        
        signUp.setTitleColor(UIColor.white, for: .normal)
        signUp.layer.shadowColor = UIColor.white.cgColor
        signUp.layer.shadowRadius = 2
        signUp.layer.shadowOpacity = 0.2
        signUp.layer.shadowOffset = CGSize(width: 0, height: 0)
     
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            DispatchQueue.main.async {
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: [], //options: nil
                    animations: ({

                        self.visualEffectView.alpha = 0.9
                        self.view.addSubview(self.popOver)
                        self.popOver.center.y = self.view.frame.width / 2

                        self.popOver.frame = CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: self.view.frame.size.height )
                    }), completion: nil)
                
                
                
               // let token: [String: AnyObject] = [Messaging.messaging().fcmToken!: Messaging.messaging().fcmToken as AnyObject]
                
                
        if Auth.auth().currentUser != nil {
           DBService.shared.users.child(Auth.auth().currentUser!.uid).child("Yes").observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                
            if snapshot.exists(){
                   print("User Signed In")
                
        //    self.postToken(Token: token)
               //p;il  =-=-0v9self.ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("notificationTokens").updateChildValues(token)


                   self.performSegue(withIdentifier: "homepageVC", sender: nil)
                    
               } else {
                   
                   Auth.auth().currentUser?.delete(completion: nil)
                   
                    print("User Didn't Complete Sign In")

                }
               
                        })
                    }
                }

        
        email.resignFirstResponder()
        
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        

        let pastelView = PastelView(frame: view.bounds)

        //MARK: -  Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight

        //MARK: -  Custom Duration

        pastelView.animationDuration = 3.00

        //MARK: -  Custom Color
        pastelView.setColors([

            UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),


            UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),



        UIColor(red: 50/255, green: 157/255, blue: 240/255, alpha: 1.0)])

        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 1)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        email.resignFirstResponder()
        
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    //FACEBOOK INTEGRATION
    
    

    
    @objc func loginButtonClicked() {
           
           hud.textLabel.text =  "Logging in with Facebook..."
           hud.show(in: view, animated: true)
                    

           
           let loginManager = LoginManager()
                  loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
                      if let error = error {
                          print("Failed to login: \(error.localizedDescription)")
                          return
                      }
                      
                      guard let accessToken = AccessToken.current else {
                          print("Failed to get access token")
                          return
                      }
           
                      let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                      
                      // Perform login by calling Firebase APIs
                      Auth.auth().signIn(with: credential, completion: { (user, error) in
                        
                        let id = Auth.auth().currentUser?.uid
                        let ref = Database.database().reference(withPath: "Users")

                        ref.child(id!).observeSingleEvent(of: .value, with: {(snapshot) in
                            if snapshot.exists() {
                                
                                
                                self.performSegue(withIdentifier: "homepageVC", sender: nil)
                                print("Successfully logged into Firebase")
                                self.hud.dismiss(animated: true)

                            
                                
                                
                            } else {
                                
                                
                                //User is signing UP
                                 print("Login error: \(String(describing: error?.localizedDescription))")
                                                               let alertController = UIAlertController(title: "Login Error", message: error?.localizedDescription, preferredStyle: .alert)
                                                               let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                                               alertController.addAction(okayAction)
                                                               self.present(alertController, animated: true, completion: nil)
                                
                                
                                
                            }
                        

                      
                      })
           
                  })
               }
    }
    
    
                  
              
//
//    fileprivate func signIntoFirebase(accessToken: String) {
//
//       // guard let authenticationToken = AccessToken.current?.authenticationToken else {return}
//
//        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
//
//        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
//            if let error = error {
//                Service.dismissHud(self.hud, text: "Sign Up Error", detailText: error.localizedDescription, delay: 1)
//                return
//            }
//
//
//            self.performSegue(withIdentifier: "homepageVC", sender: nil)
//            print("Successfully logged into Firebase")
//            self.hud.dismiss(animated: true)
//
//        }
//    }
    
   override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
    
    ref = Database.database().reference()

                    let biometricEnabled = UserDefaults.standard.value(forKey: NewConstants.kBiometricEnabled) as? Bool
                    if biometricEnabled != nil && biometricEnabled == true && biometricAuth.canEvaluatePolicy() {
                        biometricButton.isHidden = false
                        
                    } else {
                        biometricButton.isHidden = true
                    }
                    
                    switch biometricAuth.biometricType() {
                    case .FaceID:
                        biometricButton.setImage(#imageLiteral(resourceName: "faceid"), for: UIControl.State.normal)
                    default:
                        biometricButton.setImage(#imageLiteral(resourceName: "touchid"), for: UIControl.State.normal)
                    }
                    
                    
                    if let userName = UserDefaults.standard.value(forKey: NewConstants.kUserName) as? String {
                        email.text = userName
            
                    }
    
     // if Auth.auth().currentUser != nil {
            
      //  DBService.shared.users.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                
        //       print(snapshot)
                
          //     if (snapshot.value as? [String: Any]) != nil {
           //        print("User Signed In")
            //        self.performSegue(withIdentifier: "homepageVC", sender: nil)
            //    } else {
            //       Auth.auth().currentUser?.delete(completion: nil)
           //    }
         //  })
            
       // } else {
        //    print("User Not Signed In")
       }
    
    
    
    
       func displayHUD() {
            SHUD.show(self.view, style: SHUDStyle.light, alignment: SHUDAlignment.horizontal, type: SHUDType.loading, text: "Logging in. Please wait...", nil)
       }
       
       func removeHUD() {
           SHUD.hide()
       }
    
    
    
    
    //UITextFieldDelegate
    
    private func configureTextFields() {
        email.delegate = self
        password.delegate = self
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("You typed : \(string)")
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func textFieldDidChange(_ target:UITextField) {
        
        signInPressed.isEnabled = false
        guard let email = email.text,
            
            email != "" else {
                
                print("textField 1 is empty")
                return
        }
        guard let password = password.text,
            
            password != "" else {
                
                print("textField 2 is empty")
                return
        }
        // set button to true whenever all textfield criteria is met.
        signInPressed.isEnabled = true
        
        signInPressed.backgroundColor = UIColor.white
        
        signInPressed.setTitle("Sign In", for: .normal)
        signInPressed.setTitleColor(UIColor.blue, for: .normal)
        
        
       // signIn.backgroundColor = UIColor.white
        
    }
    
    func signInPressed(enabled:Bool) {
        
        if enabled{
            
    

            signInPressed.alpha = 1.0
            signInPressed.isEnabled = true
            
        } else {
            
            signInPressed.alpha = 0.5
            signInPressed.isEnabled = false
        }
    }
    
    
    @IBAction func canclePressed(_ sender: Any) {
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.popOver.alpha = 0
            self.popOver.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            
            self.dismiss(animated: true, completion: nil)

            self.popOver.removeFromSuperview()
            print("Did remove pop up window..")
        }
    }
    
    
    @IBAction func agreePressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.popOver.alpha = 0
            self.popOver.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            
            self.dismiss(animated: true, completion: nil)

            self.popOver.removeFromSuperview()
            print("Did remove pop up window..")
        }
    }
    
    
    var badParameters:Bool = true
    
    
    
    
    @IBAction func forgetPassword(_ sender: Any) {
        
        let forgetPswAlert = UIAlertController(title: "Forgot Password?", message: "Don't Worry. Reset your password here! ", preferredStyle: .alert)
        forgetPswAlert.addTextField {(textField) in
            
            textField.placeholder = "Enter your email address"
        }
        forgetPswAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(forgetPswAlert, animated: true, completion: nil)
        
        
        forgetPswAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
            
            
            let resetEmail = forgetPswAlert.textFields?.first?.text
            
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                if error != nil {
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error:\(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                } else {
                    
                    let resetFailedAlert = UIAlertController(title: "Reset Email Sent", message: " An email to reset your password has been sent succesfully. Please check email for further instructions", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert,animated: true, completion: nil )
                    
                    
                }
            })
        }))
    }
    
    
    
    
    @IBAction func signUpPRESSED(_ sender: Any) {
        
        self.performSegue(withIdentifier: "showSignUp", sender: nil)
        print("clicked")
        
        
    }
    
    func presentSignupAlertView() {
        let alertController = UIAlertController(title: "Error", message: "Couldn't create account", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func presentLoginAlertView() {
        let alertController = UIAlertController(title: "Error", message: "Email/password is incorrect", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func postToken(Token: [String : AnyObject]){
        
        print("FCM Token: \(Token)")
        
        let dbRef = Database.database().reference()
        dbRef.child("fcmToken").child(Messaging.messaging().fcmToken!).setValue(Token)
        dbRef.child("fcmToken").child(Messaging.messaging().fcmToken!).updateChildValues(Token)

        
        
    }
    
    func authenticateUserWith(email: String, password: String) {
                         Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                             
                             self.removeHUD()
                             
                             guard error == nil else {
                                 self.showAlert(message: error!.localizedDescription)
                                 return
                                 
                             }
                             guard let _ = result?.user else {return}
                             
                             // save user's credetials in keychain
                             if UserDefaults.standard.value(forKey: NewConstants.kUserName) == nil {
                                 // save user's username into userdefaults
                                 let userDefaults = UserDefaults.standard
                                 userDefaults.set(email, forKey: NewConstants.kUserName)
                                 userDefaults.synchronize()
                                 // save password into keychain
                                 let passwordItem = KeychainPasswordItem(service: KeychainConfig.serviceName, account: email, accessGroup: KeychainConfig.accessGroup)
                                 do {
                                     try passwordItem.savePassword(password)
                                 }
                                 catch let err {
                                     fatalError("Error updating keychain: \(err.localizedDescription)")
                                 }
                             }
                             
                             let biometricEnabled = UserDefaults.standard.value(forKey: NewConstants.kBiometricEnabled) as? Bool
                             if biometricEnabled != nil && biometricEnabled == true {
                                
                                 self.performSegue(withIdentifier: "homepageVC", sender: self)
                             } else if self.biometricAuth.canEvaluatePolicy() == true {
                                 self.performSegue(withIdentifier: "showBiometric", sender: self)
                             } else {
                                 self.performSegue(withIdentifier: "homepageVC", sender: self)
                             }
                             
                             
                            
                         }
                     }
                  
    
    
    @IBAction func signinPRESSED(_ sender: Any){
        
       // let token: [String: AnyObject] = [Messaging.messaging().fcmToken!: Messaging.messaging().fcmToken as AnyObject]
    

        
        validator.validate(self)
        
        guard let email = email.text, let password = password.text else {return}
        
        
        FriendSystem.system.loginAccount(email, password: password) { (success) in
            if success {
                self.performSegue(withIdentifier: "homepageVC", sender: nil)
                
              func authenticateUserWith(email: String, password: String) {
                       Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                           
                           self.removeHUD()
                           
                           guard error == nil else {
                               self.showAlert(message: error!.localizedDescription)
                               return
                               
                           }
                           guard let _ = result?.user else {return}
                           
                           // save user's credetials in keychain
                           if UserDefaults.standard.value(forKey: NewConstants.kUserName) == nil {
                               // save user's username into userdefaults
                               let userDefaults = UserDefaults.standard
                               userDefaults.set(email, forKey: NewConstants.kUserName)
                               userDefaults.synchronize()
                               // save password into keychain
                               let passwordItem = KeychainPasswordItem(service: KeychainConfig.serviceName, account: email, accessGroup: KeychainConfig.accessGroup)
                               do {
                                   try passwordItem.savePassword(password)
                               }
                               catch let err {
                                   fatalError("Error updating keychain: \(err.localizedDescription)")
                               }
                           }
                           
                           let biometricEnabled = UserDefaults.standard.value(forKey: NewConstants.kBiometricEnabled) as? Bool
                           if biometricEnabled != nil && biometricEnabled == true {
                               self.performSegue(withIdentifier: "homepageVC", sender: self)
                           } else if self.biometricAuth.canEvaluatePolicy() == true {
                               self.performSegue(withIdentifier: "showBiometric", sender: self)
                           } else {
                               self.performSegue(withIdentifier: "homepageVC", sender: self)
                           }
                           
                           
                          
                       }
                   }
                
              //  self.postToken(Token: token)
                
                //print(self.userID!)
                
                
                // let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //let signinvc = storyboard.instantiateViewController(withIdentifier: "Home")
                
                // self.present(signinvc, animated: true, completion: nil)
                print("User has Signed In")
            } else {
                // Error
                self.presentSignupAlertView()
            }
        }
}
    
    
    func showAlert(message: String) {
           let alertVC = UIAlertController(title: "Error!", message: message, preferredStyle: UIAlertController.Style.alert)
           alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
           present(alertVC, animated: true, completion: nil)
       }
    
    
    @IBAction func loginWithBiometricAuth(_ sender: Any) {
        
        biometricAuth.authenticateUser { (message) in
                   
                   self.displayHUD()
                   
                   if let message = message {
                    
                      self.performSegue(withIdentifier: "homepageVC", sender: self)
                       self.removeHUD()
                       self.showAlert(message: message)
                    
                    
                       return
                   }
                   
                   if let username = UserDefaults.standard.value(forKey: NewConstants.kUserName) as? String {
                       do {
                           let passwordItem = KeychainPasswordItem(service: KeychainConfig.serviceName, account: username, accessGroup: KeychainConfig.accessGroup)
                           let password = try passwordItem.readPassword()
                           self.authenticateUserWith(email: username, password: password)
                       } catch let err {
                        

                           print("Error authenticating: \(err.localizedDescription)")
                       }

                   }
            
           // self.performSegue(withIdentifier: "homepageVC", sender: self)
            AlertView.instance.showAlert(title: "Failure", message: "You are not logged into the system.", alertType: .failure)

          self.removeHUD()

               }

    }
    
    
}

@available(iOS 13.0, *)

extension SignInVC: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
}
}
    
extension SignInVC: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Save authorised user ID for future reference
            UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
            
            // Retrieve the secure nonce generated during Apple sign in
            guard let nonce = self.currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }

            // Retrieve Apple identity token
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Failed to fetch identity token")
                return
            }

            // Convert Apple identity token to string
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Failed to decode identity token")
                return
            }

            // Initialize a Firebase credential using secure nonce and Apple identity token
            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                              idToken: idTokenString,
                                                              rawNonce: nonce)
                
            // Sign in with Firebase
            Auth.auth().signIn(with: firebaseCredential) { (authResult, error) in
                
                if let error = error {
                    
                    self.performSegue(withIdentifier: "homepageVC", sender: self)

                    print(error.localizedDescription)
                    return
                }
                
                self.performSegue(withIdentifier: "showSignUp", sender: nil)
                print("SignUpCLciked")
              
            }
            
        }
    }
}

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

public extension UIDevice {
   
   var type: Model {
       var systemInfo = utsname()
       uname(&systemInfo)
       let modelCode = withUnsafePointer(to: &systemInfo.machine) {
           $0.withMemoryRebound(to: CChar.self, capacity: 1) {
               ptr in String.init(validatingUTF8: ptr)
           }
       }
   
       let modelMap : [String: Model] = [
   
           //Simulator
           "i386"      : .simulator,
           "x86_64"    : .simulator,
   
           //iPod
           "iPod1,1"   : .iPod1,
           "iPod2,1"   : .iPod2,
           "iPod3,1"   : .iPod3,
           "iPod4,1"   : .iPod4,
           "iPod5,1"   : .iPod5,
           "iPod7,1"   : .iPod6,
           "iPod9,1"   : .iPod7,
   
           //iPad
           "iPad2,1"   : .iPad2,
           "iPad2,2"   : .iPad2,
           "iPad2,3"   : .iPad2,
           "iPad2,4"   : .iPad2,
           "iPad3,1"   : .iPad3,
           "iPad3,2"   : .iPad3,
           "iPad3,3"   : .iPad3,
           "iPad3,4"   : .iPad4,
           "iPad3,5"   : .iPad4,
           "iPad3,6"   : .iPad4,
           "iPad6,11"  : .iPad5, //iPad 2017
           "iPad6,12"  : .iPad5,
           "iPad7,5"   : .iPad6, //iPad 2018
           "iPad7,6"   : .iPad6,
           "iPad7,11"  : .iPad7, //iPad 2019
           "iPad7,12"  : .iPad7,
           "iPad11,6"  : .iPad8, //iPad 2020
           "iPad11,7"  : .iPad8,
           "iPad12,1"  : .iPad9, //iPad 2021
           "iPad12,2"  : .iPad9,
   
           //iPad Mini
           "iPad2,5"   : .iPadMini,
           "iPad2,6"   : .iPadMini,
           "iPad2,7"   : .iPadMini,
           "iPad4,4"   : .iPadMini2,
           "iPad4,5"   : .iPadMini2,
           "iPad4,6"   : .iPadMini2,
           "iPad4,7"   : .iPadMini3,
           "iPad4,8"   : .iPadMini3,
           "iPad4,9"   : .iPadMini3,
           "iPad5,1"   : .iPadMini4,
           "iPad5,2"   : .iPadMini4,
           "iPad11,1"  : .iPadMini5,
           "iPad11,2"  : .iPadMini5,
           "iPad14,1"  : .iPadMini6,
           "iPad14,2"  : .iPadMini6,
   
           //iPad Pro
           "iPad6,3"   : .iPadPro9_7,
           "iPad6,4"   : .iPadPro9_7,
           "iPad7,3"   : .iPadPro10_5,
           "iPad7,4"   : .iPadPro10_5,
           "iPad6,7"   : .iPadPro12_9,
           "iPad6,8"   : .iPadPro12_9,
           "iPad7,1"   : .iPadPro2_12_9,
           "iPad7,2"   : .iPadPro2_12_9,
           "iPad8,1"   : .iPadPro11,
           "iPad8,2"   : .iPadPro11,
           "iPad8,3"   : .iPadPro11,
           "iPad8,4"   : .iPadPro11,
           "iPad8,9"   : .iPadPro2_11,
           "iPad8,10"  : .iPadPro2_11,
           "iPad13,4"  : .iPadPro3_11,
           "iPad13,5"  : .iPadPro3_11,
           "iPad13,6"  : .iPadPro3_11,
           "iPad13,7"  : .iPadPro3_11,
           "iPad8,5"   : .iPadPro3_12_9,
           "iPad8,6"   : .iPadPro3_12_9,
           "iPad8,7"   : .iPadPro3_12_9,
           "iPad8,8"   : .iPadPro3_12_9,
           "iPad8,11"  : .iPadPro4_12_9,
           "iPad8,12"  : .iPadPro4_12_9,
           "iPad13,8"  : .iPadPro5_12_9,
           "iPad13,9"  : .iPadPro5_12_9,
           "iPad13,10" : .iPadPro5_12_9,
           "iPad13,11" : .iPadPro5_12_9,
   
           //iPad Air
           "iPad4,1"   : .iPadAir,
           "iPad4,2"   : .iPadAir,
           "iPad4,3"   : .iPadAir,
           "iPad5,3"   : .iPadAir2,
           "iPad5,4"   : .iPadAir2,
           "iPad11,3"  : .iPadAir3,
           "iPad11,4"  : .iPadAir3,
           "iPad13,1"  : .iPadAir4,
           "iPad13,2"  : .iPadAir4,
           "iPad13,16" : .iPadAir5,
           "iPad13,17" : .iPadAir5,
   
           //iPhone
           "iPhone3,1" : .iPhone4,
           "iPhone3,2" : .iPhone4,
           "iPhone3,3" : .iPhone4,
           "iPhone4,1" : .iPhone4S,
           "iPhone5,1" : .iPhone5,
           "iPhone5,2" : .iPhone5,
           "iPhone5,3" : .iPhone5C,
           "iPhone5,4" : .iPhone5C,
           "iPhone6,1" : .iPhone5S,
           "iPhone6,2" : .iPhone5S,
           "iPhone7,1" : .iPhone6Plus,
           "iPhone7,2" : .iPhone6,
           "iPhone8,1" : .iPhone6S,
           "iPhone8,2" : .iPhone6SPlus,
           "iPhone8,4" : .iPhoneSE,
           "iPhone9,1" : .iPhone7,
           "iPhone9,3" : .iPhone7,
           "iPhone9,2" : .iPhone7Plus,
           "iPhone9,4" : .iPhone7Plus,
           "iPhone10,1" : .iPhone8,
           "iPhone10,4" : .iPhone8,
           "iPhone10,2" : .iPhone8Plus,
           "iPhone10,5" : .iPhone8Plus,
           "iPhone10,3" : .iPhoneX,
           "iPhone10,6" : .iPhoneX,
           "iPhone11,2" : .iPhoneXS,
           "iPhone11,4" : .iPhoneXSMax,
           "iPhone11,6" : .iPhoneXSMax,
           "iPhone11,8" : .iPhoneXR,
           "iPhone12,1" : .iPhone11,
           "iPhone12,3" : .iPhone11Pro,
           "iPhone12,5" : .iPhone11ProMax,
           "iPhone12,8" : .iPhoneSE2,
           "iPhone13,1" : .iPhone12Mini,
           "iPhone13,2" : .iPhone12,
           "iPhone13,3" : .iPhone12Pro,
           "iPhone13,4" : .iPhone12ProMax,
           "iPhone14,4" : .iPhone13Mini,
           "iPhone14,5" : .iPhone13,
           "iPhone14,2" : .iPhone13Pro,
           "iPhone14,3" : .iPhone13ProMax,
           "iPhone14,6" : .iPhoneSE3,
           
           // Apple Watch
           "Watch1,1" : .AppleWatch1,
           "Watch1,2" : .AppleWatch1,
           "Watch2,6" : .AppleWatchS1,
           "Watch2,7" : .AppleWatchS1,
           "Watch2,3" : .AppleWatchS2,
           "Watch2,4" : .AppleWatchS2,
           "Watch3,1" : .AppleWatchS3,
           "Watch3,2" : .AppleWatchS3,
           "Watch3,3" : .AppleWatchS3,
           "Watch3,4" : .AppleWatchS3,
           "Watch4,1" : .AppleWatchS4,
           "Watch4,2" : .AppleWatchS4,
           "Watch4,3" : .AppleWatchS4,
           "Watch4,4" : .AppleWatchS4,
           "Watch5,1" : .AppleWatchS5,
           "Watch5,2" : .AppleWatchS5,
           "Watch5,3" : .AppleWatchS5,
           "Watch5,4" : .AppleWatchS5,
           "Watch5,9" : .AppleWatchSE,
           "Watch5,10" : .AppleWatchSE,
           "Watch5,11" : .AppleWatchSE,
           "Watch5,12" : .AppleWatchSE,
           "Watch6,1" : .AppleWatchS6,
           "Watch6,2" : .AppleWatchS6,
           "Watch6,3" : .AppleWatchS6,
           "Watch6,4" : .AppleWatchS6,
           "Watch6,6" : .AppleWatchS7,
           "Watch6,7" : .AppleWatchS7,
           "Watch6,8" : .AppleWatchS7,
           "Watch6,9" : .AppleWatchS7,
   
           //Apple TV
           "AppleTV1,1" : .AppleTV1,
           "AppleTV2,1" : .AppleTV2,
           "AppleTV3,1" : .AppleTV3,
           "AppleTV3,2" : .AppleTV3,
           "AppleTV5,3" : .AppleTV4,
           "AppleTV6,2" : .AppleTV_4K,
           "AppleTV11,1" : .AppleTV2_4K
       ]
   
       guard let mcode = modelCode, let map = String(validatingUTF8: mcode), let model = modelMap[map] else { return Model.unrecognized }
       if model == .simulator {
           if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
               if let simMap = String(validatingUTF8: simModelCode), let simModel = modelMap[simMap] {
                   return simModel
               }
           }
       }
       return model
       }
   }


