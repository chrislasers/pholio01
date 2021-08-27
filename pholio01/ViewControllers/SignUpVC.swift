//
//  SignUpVC.swift
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
import FacebookShare
import LBTAComponents
import JGProgressHUD
import Photos
import FirebaseFirestore
import Pastel
import InstagramLogin
import AuthenticationServices
import CryptoKit




class SignUpVC: UIViewController, UITextFieldDelegate, ValidationDelegate {
    
    
    
    
    
    func validationSuccessful() {
        
    
        validator.registerField(email, errorLabel: emailValid, rules: [RequiredRule(), EmailRule(message: "Invalid email")])
        
        validator.registerField(password, errorLabel: passwordValid, rules: [RequiredRule(), PasswordRule(message: "Must be 6 characters")])
        
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
    

    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    
    @IBOutlet weak var emailValid: UILabel!
    
    @IBOutlet weak var passwordValid: UILabel!
    
    
    @IBOutlet weak var fbValid: UILabel!
    
    
    @IBOutlet var orBTN: UILabel!
    
    var imagePicker:UIImagePickerController!
    var selectedImage: UIImage!
    let validator = Validator()
    var ref: DatabaseReference!
    
    
    
    let userID = Auth.auth().currentUser?.uid
    
    let storage = Storage.storage()
    
    let metaData = StorageMetadata()
    
    // MARK: - Firebase references
    /** The base Firebase reference */
    let BASE_REF = Database.database().reference()
    /* The user Firebase reference */
    let USER_REF = Database.database().reference().child("users")
    
    /** The Firebase reference to the current user tree */
    var CURRENT_USER_REF: DatabaseReference {
        let id = Auth.auth().currentUser?.uid
        return USER_REF.child(id!)
    }
    
    /** The Firebase reference to the current user's friend tree */
    var CURRENT_USER_FRIENDS_REF: DatabaseReference {
        return CURRENT_USER_REF.child("friends")
    }
    
    /** The Firebase reference to the current user's friend request tree */
    var CURRENT_USER_REQUESTS_REF: DatabaseReference {
        return CURRENT_USER_REF.child("requests")
    }
    
    /** The current user's id */
    var CURRENT_USER_ID: String {
        let id = Auth.auth().currentUser!.uid
        return id
    }

    
    override func viewDidLoad() {
        
        
        let button = UIButton(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "back"), for: .normal)
        //add function for button
        button.addTarget(self, action: #selector(fbButtonPressed), for: .touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 21, height: 21)
        
        let widthConstraint = button.widthAnchor.constraint(equalToConstant: 21)
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 21)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
        
        
        
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if Auth.auth().currentUser != nil
            {
                print("User Signed In")
                //self.performSegue(withIdentifier: "homepageVC", sender: nil)    }
                
            }  else {
                
                
                print("User Not Signed In")
            }
        }
        
        setupSignInButton()
        
        
        var signInWithFbButton: UIButton {
            
            // Add a custom login button to your app
            let myLoginButton = UIButton(type: .custom)
            myLoginButton.backgroundColor = UIColor(r: 73, g: 103, b: 173)
            myLoginButton.frame = CGRect(x: 50, y: 470, width: view.frame.width - 105, height: 47)
            myLoginButton.setTitle("Login with Facebook", for: .normal)
            myLoginButton.setTitleColor(UIColor.white, for: .normal)
            myLoginButton.layer.cornerRadius = 7
            

            myLoginButton.setImage(#imageLiteral(resourceName: "flogo_RGB_HEX-144").withRenderingMode(.automatic), for: .normal)
            myLoginButton.tintColor = .white
            myLoginButton.contentMode = .scaleAspectFill
            
            
            myLoginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize:  18)
            myLoginButton.layer.masksToBounds = true
            // Handle clicks on the button
            myLoginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
            
            
            
            _ = UIDevice().type.rawValue
            
            switch UIDevice().type {
                
            case .iPhone5,.iPhone5S, .iPhoneSE:
                
                myLoginButton.frame = CGRect(x: 40, y: 450, width: 253, height: 47)
            
                
            default:break
            }
            
            
            return myLoginButton
        }
        // Add the FACEBOOK button to the view
        //view.addSubview(signInWithFbButton)
        
        
        let tf = CustomTextField(padding: 24, height: 44)
        
        tf.layer.cornerRadius =  tf.height / 2
        
        tf.placeholder = "Enter Username"
        tf.backgroundColor = .white
        
        password.keyboardType = .default
        password.placeholder = "Enter Password"
        
        
        email.keyboardType = .emailAddress
        email.placeholder = "Enter Email "
        
        super.viewDidLoad()
        
        fbValid.isHidden = true
        
        signUpButton.backgroundColor = UIColor.orange
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
        signUpButton.layer.borderWidth = 1.5
        signUpButton.layer.cornerRadius = 4
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        //signUp.layer.shadowColor = UIColor.white.cgColor
        // signUp.layer.shadowRadius = 5
        signUpButton.layer.shadowOpacity = 0.5
        signUpButton.layer.shadowOffset = CGSize(width: 1, height: 1)


     
       
        
        
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings

    
        
        configureTextFields()
        ref = Database.database().reference()
        
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
    

        
        validator.registerField(email, errorLabel: emailValid, rules: [RequiredRule(), EmailRule(message: "Invalid email")])
        

        validator.registerField(password, errorLabel: passwordValid, rules: [RequiredRule(), PasswordRule(message: "Must be 6 characters long or more.")])
        
        
        
        emailValid.isHidden = true
        passwordValid.isHidden = true
        
        
       
        signUpButton.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
        
        signUpButton(enabled: false)
        
        
        
        
        
        email.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        password.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
     
        
        email.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        email.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        email.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEndOnExit )

        password.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        password.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        password.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEndOnExit )
        
        
       /////////////////////////////////////////////
        
       
        
        
     
        
       email.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingChanged)
        email.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidBegin)
        email.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        email.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEndOnExit )
        
        password.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingChanged)
        password.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidBegin)
        password.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        password.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEndOnExit )
        
    
        //////////////Listens For Keyboard Events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        
        guard ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -160
        } else {
            
            view.frame.origin.y = 0
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        email.becomeFirstResponder()
        
        
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
        
        //   UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
        
        
        //  UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 1)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        email.resignFirstResponder()
        password.resignFirstResponder()
            }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // sender object is an instance of UITouch in this case
        let touch = sender as! UITouch
        
        // Access the circleOrigin property and assign preferred CGPoint
        (segue as! OHCircleSegue).circleOrigin = touch.location(in: view)
    }
    
    func setupSignInButton() {
        
        let signInButton = ASAuthorizationAppleIDButton()
        signInButton.addTarget(self, action: #selector(handleSignWithAppleTapped), for: .touchUpInside)
       
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signInButton)
        
        
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -300),
                   signInButton.heightAnchor.constraint(equalToConstant: 45),
                   signInButton.widthAnchor.constraint(equalToConstant: 250)
               ])
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

    
    //FACEBOOK INTEGRATION
   
    @objc func fbButtonPressed() {
        
                      //let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   // let signinvc = storyboard.instantiateViewController(withIdentifier: "UpdateVC")
                    //self.present(signinvc, animated: true, completion: nil)

        
        print("Bar Button Pressed")
    }
    
    
    @objc func loginButtonClicked() {
           
           hud.textLabel.text =  "Logging in with Facebook..."
           hud.show(in: view, animated: true)
           
           _ = LoginManager()
           

           
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
                                
                                
                                print("Login error: \(String(describing: error?.localizedDescription))")
                                let alertController = UIAlertController(title: "Login Error", message: error?.localizedDescription, preferredStyle: .alert)
                                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(okayAction)
                                self.present(alertController, animated: true, completion: nil)
                                
                                
                            } else {
                                
                                
                                //User is signing UP
                                
                                self.getFacebookData()
                                self.performSegue(withIdentifier: "toEditProfile", sender: nil)
                                print("Successfully logged into Firebase")
                                self.hud.dismiss(animated: true)
                                
                                    print(" Successful Login")
                            }
                        

                      
                      })
           
                  })
               }
    }
    
    
      private func getFacebookData() {
          
    
          let params: [String:String] = ["fields": "email, id"]
          let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: params)
          graphRequest.start { (connection: GraphRequestConnection?, result: Any?, error: Error?) in
              
              if error == nil {
                  if let facebookData = result as? NSDictionary {
                      if let publicProfile = facebookData.value(forKey: FacebookPermission.PublicProfile) as? NSDictionary {
                          print("fb public profile: \(publicProfile)")
                      }
                      
                      if let email = facebookData.value(forKey: FacebookPermission.Email) as? String {
                          
                          var userInfo = [String: AnyObject]()
                          userInfo = ["email": email as AnyObject]
                          self.CURRENT_USER_REF.setValue(userInfo)
                          print("fb email: \(email)")
                      }
                      
                      if let userPhotos = facebookData.value(forKey: FacebookPermission.UserPhotos) as? NSDictionary {
                          print("fb photos: \(userPhotos)")
                      }
                  }
                  
                  
                  if let values: [String:AnyObject] = result as? [String : AnyObject] {
                  
                  // update our databse by using the child database reference above called usersReference
                      

                      self.CURRENT_USER_REF.setValue(values, withCompletionBlock: { (err, ref) in
                      // if there's an error in saving to our firebase database
                      if err != nil {
                          print(err!)
                          return
                      }
                      // no error, so it means we've saved the user into our firebase database successfully
                      print("Save the user successfully into Firebase database")
                  })
              }
              }
          }
          
      }
    
    
                  
   
    
    
    ////TextFIeldDelegates
    
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTintColorForTextFieldClearButtonIfNeeded()
        setUpTintColorForTextFieldClearButtonIfNeeded()
    }
    
   
    
    
    private func configureTextFields() {
        
        email.delegate = self
        password.delegate = self
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true}
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("You typed : \(string)")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case email:
            password.becomeFirstResponder()
        default:
            password.resignFirstResponder()
        }
        return true
    }
    
    
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            
            return true
        }
    
        
    internal func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            return
        }
    
    //////////////////////////////////////////////
    
    
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
    ////////////////////////////////////////////////////////
    
     @objc func textFieldDidChange(_ target:UITextField) {
        
     signUpButton.isEnabled = false
        
      
        guard let email = email.text,
            
            email != "" else {
            print("TEXTFIELD 3 is empty")
            return
        }
        guard let password = password.text,
            
            password != "" else {
            print("TEXTFIELD 4 is empty")
            return
        }
        // set button to true whenever all textfield criteria is met.
        signUpButton.isEnabled = true

    }
    
    
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        
        signUpButton.isEnabled = false
        
        
     
        guard let email = email.text,
            
            email != "" else {
                
                
                print("textField 3 is empty")
                return
        }
        guard let password = password.text,
            
            password != "" else {
                

                print("textField 4 is empty")
                return
        }
        // set button to true whenever all textfield criteria is met.
        signUpButton.isEnabled = true
        
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signinvc = storyboard.instantiateViewController(withIdentifier: "signinvc")
        
        self.present(signinvc, animated: true, completion: nil)
        
    }
    
    func signUpButton(enabled:Bool) {
        
        if enabled{
            

            signUpButton.alpha = 1.0
            signUpButton.isEnabled = true
            
        } else {
            signUpButton.alpha = 0.9
            signUpButton.isEnabled = false
        }
    }
   

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
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
        
        ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("fcmToken").child(Messaging.messaging().fcmToken!).setValue(Token)

        ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("fcmToken").child(Messaging.messaging().fcmToken!).updateChildValues(Token)
        

        
       // self.ref.child("Users").child(self.userID!).setValue(["tokenid":Token])
        
    }
    
    func displayHUD() {
          SHUD.show(self.view, style: SHUDStyle.light, alignment: SHUDAlignment.horizontal, type: SHUDType.loading, text: "Signing up. Please wait...", nil)
      }
      
      func removeHUD() {
          SHUD.hide()
      }
    
    func saveUserCredentials(username: String, password: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(username, forKey: NewConstants.kUserName)
        userDefaults.synchronize()
        // save password into keychain
        let passwordItem = KeychainPasswordItem(service: KeychainConfig.serviceName, account: username, accessGroup: KeychainConfig.accessGroup)
        do {
            try passwordItem.savePassword(password)
        }
        catch let err {
            self.removeHUD()
            fatalError("Error updating keychain: \(err.localizedDescription)")
        }
    }
    
    
    
    
   
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        validator.validate(self)
        
        
        let token: [String: AnyObject] = [Messaging.messaging().fcmToken!: Messaging.messaging().fcmToken as AnyObject]
        

        
        
        guard let email = email.text, let password = password.text else {return}
       
        Auth.auth().fetchProviders(forEmail: self.email.text!, completion: {
            (providers, error) in
            
            if let error = error {
                print(error.localizedDescription)
                print("Email Address Already In Use")
            } else if let providers = providers {
                print(providers)
            }
        })
        
        
        FriendSystem.system.createAccount(email, password: password) { (success) in
            if success {
                self.performSegue(withIdentifier: "toEditProfile", sender: self)
                //print(self.userID!)
                
                 self.saveUserCredentials(username: email, password: password)
                
                self.postToken(Token: token)
                
                self.ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("notificationTokens").updateChildValues(token)

                

                print("User has Signed In")
            } else {
                // Error
                self.presentSignupAlertView()
            }
        }
    }
    }



struct FacebookPermission
{
    static let Email: String = "email"
    static let UserPhotos: String = "user_photos"
    static let PublicProfile: String = "public_profile"
}


@available(iOS 13.0, *)

extension SignUpVC: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
}
}
    
extension SignUpVC: ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if (error != nil) {
          // Error. If error.code == .MissingOrInvalidNonce, make sure
          // you're sending the SHA256-hashed nonce as a hex string with
          // your request to Apple.
            print(error?.localizedDescription)
          return
        }
        // User is signed in to Firebase with Apple.
        // ...
        
        self.performSegue(withIdentifier: "toEditProfile", sender: nil)
        print("Successfully logged into Firebase")
      }
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}






