//
//  UpdateVC.swift
//  pholio01
//
//  Created by Chris  Ransom on 9/1/18.
//  Copyright © 2018 Chris Ransom. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseStorage
import SwiftValidator
import Photos
import FirebaseFirestore
import Pastel

class UpdateVC: UIViewController, UITextFieldDelegate, ValidationDelegate {
    func validationSuccessful() {
        
        validator.registerField(username, errorLabel: usernameValid , rules: [RequiredRule(), PasswordRule(message: "Must be 6 characters")])
        
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
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet weak var usernameValid: UILabel!
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var tapToChangePic: UIButton!
    
    var imagePicker:UIImagePickerController!
    var selectedImage: UIImage!
    let validator = Validator()
    
    
    var ref: DatabaseReference!
    
    
   // let userID = Auth.auth().currentUser?.uid
    
    let storage = Storage.storage()
    
    let metaData = StorageMetadata()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if Auth.auth().currentUser != nil
            {
                print("User Signed In")
                //self.performSegue(withIdentifier: "homepageVC", sender: nil)    }
                
            }  else {
                
                
                print("User Not Signed In")
            }
        }
        
        
        if let uid = Auth.auth().currentUser?.uid {
            let docData: [String: Any] = ["uid": uid]
            Firestore.firestore().collection("Users").document(uid).setData(docData)
        }
        
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
       
        
        
        let tf = CustomTextField(padding: 24, height: 44)
        tf.layer.cornerRadius =  tf.height / 2
        tf.placeholder = "Enter Username"
        tf.backgroundColor = .white
        username.keyboardType = .default
        username.placeholder = "Enter Username"
        
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        self.profileImageView.layer.borderWidth = 0.5
        self.profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        
        
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
      //  settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        checkPermission()
        
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
        
        validator.registerField(username, errorLabel: usernameValid , rules: [RequiredRule(), PasswordRule(message: "Must be 6 characters")])

        
        
        usernameValid.isHidden = true
        
        
        dismissKeyboardWhenTouchOutside()
        
        
        signUpButton.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
        
        signUpButton(enabled: false)
        
        
        self.signUpButton.backgroundColor = UIColor.orange
        
        signUpButton.setTitle("Continue", for: .normal)
        
        signUpButton.layer.borderWidth = 1
        
        signUpButton.layer.borderColor = UIColor.orange.cgColor
        
        
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.layer.shadowColor = UIColor.white.cgColor
        signUpButton.layer.shadowRadius = 2
        signUpButton.layer.shadowOpacity = 0.3
        signUpButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        
       
        
        
        
        username.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
        
        
        
        username.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin )
        username.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        username.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEndOnExit )
        
        
        
        
        /////////////////////////////////////////////
        
        username.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingChanged)
        
        
        username.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidBegin )
        username.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        username.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEndOnExit )
        
        
        
        //////////////Listens For Keyboard Events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name:
            UIResponder.keyboardWillShowNotification, object: nil)
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
        username.becomeFirstResponder()
        
        
        
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
        username.resignFirstResponder()
    }
    
    private func dismissKeyboardWhenTouchOutside() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getter: tapToChangePic)))
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // sender object is an instance of UITouch in this case
        let touch = sender as! UITouch
        
        // Access the circleOrigin property and assign preferred CGPoint
        (segue as! OHCircleSegue).circleOrigin = touch.location(in: view)
    }
    
    
    ////TextFIeldDelegates
    
    
    var didSetupWhiteTintColorForClearTextFieldButton = false
    var didsetupWhiteTintColorForClearTextFieldButton = false
    
    
    
    private func setupTintColorForTextFieldClearButtonIfNeeded() {
        // Do it once only
        if didSetupWhiteTintColorForClearTextFieldButton { return }
        
        guard let button = username.value(forKey: "_clearButton") as? UIButton else { return }
        guard let icon = button.image(for: .normal)?.withRenderingMode(.alwaysTemplate) else { return }
        button.setImage(icon, for: .normal)
        button.tintColor = .white
        didSetupWhiteTintColorForClearTextFieldButton = true
    }
   
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTintColorForTextFieldClearButtonIfNeeded()
    }
    
    
    
    
    
    
    
    private func configureTextFields() {
        
        username.delegate = self
        
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
        case username:
            username.becomeFirstResponder()
        default:
            username.resignFirstResponder()
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
        
        validator.validate(self)

        
        guard let username = username.text,
            
            username != "" else {
                print("TEXTFIELD 2 is empty")
                return
        }
        // set button to true whenever all textfield criteria is met.
        signUpButton.isEnabled = true
        
    }
    
    
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        
        signUpButton.isEnabled = false
        
        validator.validate(self)

        
        
        guard let username = username.text,
            
            username != "" else {
                print("textField 2 is empty")
                return
        }
        
        // set button to true whenever all textfield criteria is met.
        signUpButton.isEnabled = true
        
    }
    
    @objc func fbButtonPressed() {
        dismiss(animated: true, completion: nil)

        
        print("Bar Button Pressed")
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func signUpButton(enabled:Bool) {
        
        if enabled{
            
            
            signUpButton.alpha = 1.0
            signUpButton.isEnabled = true
            
        } else {
            signUpButton.alpha = 1.0
            signUpButton.isEnabled = false
        }
    }
    
    //Profile Picture Editing
    
    @IBAction func pressToChangePic(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
    
    
    func uploadProfileImage(imageData: Data) {
        
        
        let storageReference = Storage.storage().reference()
        
        let profileImageRef = storageReference.child("UserPro-Pics").child((Auth.auth().currentUser?.uid)!)
        
        let userReference = self.ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("UserPro-Pic")
        
         let UserReference = self.ref.child("users").child((Auth.auth().currentUser?.uid)!)
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        guard let imageData = profileImageView.image?.jpegData(compressionQuality: 0.75)  else {return }
        
        profileImageRef.putData(imageData, metadata: uploadMetaData) { (uploadMetaData, error) in
            
            if error != nil {
                print("Error took place \(String(describing: error?.localizedDescription))")
                return } else {
                
                
                profileImageRef.downloadURL(completion: { (metadata, error) in
                    if let downloadUrl = metadata {
                        // Make you download string
                        let profileImageURL = downloadUrl.absoluteString
                        userReference.setValue(["profileImageURL": profileImageURL])
                        
                        UserReference.updateChildValues(["profileImageURL": profileImageURL])
                        
                        let uid = Auth.auth().currentUser?.uid ?? ""
                        let docData = ["uid": uid, "profileImageURL": profileImageURL]
                        
                        
                        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
                            if let err = err {
                                print(err)
                                return
                            } else {
                                print(docData)
                                
                                print("Meta data of upload image \(String(describing: uploadMetaData))")
                                
                                print(profileImageURL)

                            }
                        print(profileImageURL)
                    }
                }
            })
            
            
        }
    }
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
         default:
            fatalError()
        }
    }
    
    
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        validator.validate(self)
    
        
        
        guard let username = username.text else {
            
            let loginAlert = UIAlertController(title: "Login Error", message: " Please Provide Valid Username", preferredStyle: .alert)
            loginAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(loginAlert, animated: true, completion: nil)
            return
            
        }
        
        guard let image = profileImageView.image?.jpegData(compressionQuality: 0.7)   else {
            
            
            let loginAlert = UIAlertController(title: "Login Error", message: " Please Add Profile Picture", preferredStyle: .alert)
            loginAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(loginAlert, animated: true, completion: nil)
            
            return }
        

        if self.profileImageView?.image != nil   {
            
            print("Image1")
            //Now check if the img has changed or not:
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges { error in
                
                if error == nil {
                    
                    self.uploadProfileImage(imageData: image) // upload image from here
                    self.performSegue(withIdentifier: "toGallery", sender: self)
                    
                    self.ref.child("Users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["Username": self.username.text!])
                    
                     self.ref.child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["username": self.username.text!])
                    print("User display changed")
                    
                } else {
                    print(error as Any)
                }
                print("Image3")
            }
        } else {
            
            print("Image4")

        }
        print("Image5")
    }
}


extension UpdateVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
                
            })
        } else {
            
            if let profileImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            {
                
                picker.dismiss(animated: true, completion:nil)
                
                profileImageView.image = profileImage
            }
            
        }
        
        
        
    }
}
