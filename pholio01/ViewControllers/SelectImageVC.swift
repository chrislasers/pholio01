//
//  SelectImageVC.swift
//  pholio01
//
//  Created by Chris  Ransom on 6/3/18.
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
import Alamofire
import FirebaseCore
import BSImagePicker
import JGProgressHUD
import Pastel






class SelectImageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UploadImagesPresenterDelegate   {
    
    
    
   
    
    
    @IBOutlet weak var collectionView: UICollectionView!
        
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet weak var pickImageBTN: UIButton!
    
    
    @IBOutlet weak var progressView: UIProgressView!
    
    private var uploadPresenter: UploadPresenter!

    private var uploadImagePresenter: UploadImagePresenter!
    
    
    
   
   
    //var ref: DocumentReference? = nil
    var SelectedAssets = [PHAsset]()
    var PhotoArray = [UIImage]()
    
    
    let testVC = UploadimageCell()
    
    
    func uploadImagesPresenterDidScrollTo(index: Int) {
        func uploadImagesPresenterDidScrollTo(index: Int) {
            pageControl.currentPage = index
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        
        uploadPresenter = UploadPresenter(viewController: self)
        uploadImagePresenter = UploadImagePresenter()
        uploadImagePresenter.delegate = self
        collectionView.dataSource = uploadImagePresenter
        collectionView.delegate = uploadImagePresenter
        
        
        
        
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
        
       
        
        pickImageBTN.backgroundColor = UIColor.orange
        pickImageBTN.setTitle("Press Here To Select Image", for: .normal)
        pickImageBTN.layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
        pickImageBTN.layer.borderWidth = 1.5
       // pickImageBTN.layer.cornerRadius = 4
        pickImageBTN.setTitleColor(UIColor.white, for: .normal)
        //signUp.layer.shadowColor = UIColor.white.cgColor
        // signUp.layer.shadowRadius = 5
        pickImageBTN.layer.shadowOpacity = 0.5
        pickImageBTN.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        
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
        
        
        
        
        // pickImageBTN.frame = CGRect(x: 300, y: 100, width: 50, height: 50)
        
        //Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            
          //  if error != nil {
                
            //    let emailNotSentAlert = UIAlertController(title: "Email Verification", message: "Verification failed to send: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
            //    emailNotSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            //    self.present(emailNotSentAlert, animated: true, completion: nil)
                
            //    print("Email Not Sent")
           // }
                
           // else {
                
           //     let emailSentAlert = UIAlertController(title: "Email Verification", message: "Verification email has been sent. Please tap on the link in the email to verify your account before you can use the features assoicited within the app", preferredStyle: .alert)
                //emailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
               // self.present(emailSentAlert, animated: true, completion: nil)//
                
             //   print("Email Sent")
            //}
       // })


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // sender object is an instance of UITouch in this case
        let touch = sender as! UITouch
        
        // Access the circleOrigin property and assign preferred CGPoint
        (segue as! OHCircleSegue).circleOrigin = touch.location(in: view)
    }
    
    @objc func fbButtonPressed() {
        
        dismiss(animated: true, completion: nil)

        
        print("Bar Button Pressed")
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func postToken(Token: [String : AnyObject]){
        
        print("FCM Token: \(Token)")
        
        
        ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("fcmToken").child(Messaging.messaging().fcmToken!).updateChildValues(Token)
        
        // self.ref.child("Users").child(self.userID!).setValue(["tokenid":Token])
        
    }
    
    
    
    @IBAction func savePressed(_ sender: Any) {
        
        
        guard uploadImagePresenter.images.count > 1, let images = uploadImagePresenter.images as? [UIImage] else
            
        {
            print("No Image Selected")
            
            
             let emailNotSentAlert = UIAlertController(title: "More Photos Needed", message: "Please select at least one more photo to continue", preferredStyle: .alert)
              emailNotSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               self.present(emailNotSentAlert, animated: true, completion: nil)
            
            return
        }
        
        let token: [String: AnyObject] = [Messaging.messaging().fcmToken!: Messaging.messaging().fcmToken as AnyObject]

        
        self.postToken(Token: token)

        
       performSegue(withIdentifier: "toAddPhoto", sender: self)
       uploadPresenter.createCar(with: images)
       
    }
    
    
    

    func addButton() -> UIBarButtonItem {
        
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePressed(_:)))
    }
    
    func updateProgressView(with percentage: Float) {
        progressView.progress = percentage
    }
    
    func handleError(_ error: String) {
        let alertViewController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }

    
    func userSelectedimage(_ image: UIImage) {
        
        uploadImagePresenter.add(image: image)
        collectionView.reloadData()
        
        let offsetX = collectionView.frame.width * CGFloat(uploadImagePresenter.images.count-1)
        
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0.00), animated: true)
        
        pageControl.numberOfPages = uploadImagePresenter.images.count
        pageControl.currentPage = uploadImagePresenter.images.count-1
    }
    
    @objc func getAllImg() -> Void
        {
            DispatchQueue.main.async {
                // Update UI
            
                if self.SelectedAssets.count != 0{
                    for i in 0..<self.SelectedAssets.count{
    //                let manager = PHImageManager.default()
                    let option = PHImageRequestOptions()
                        
                    var thumbnail = UIImage()
                        
                        option.isSynchronous = true
                        //option.deliveryMode = .highQualityFormat
                        option.resizeMode = .fast
                    
                        


                        PHCachingImageManager.default().requestImage(for: self.SelectedAssets[i], targetSize:CGSize(width: 700, height: 700), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                            
                            // Cuts off at thumbnail...fix NOW!!
                            if result == nil {
                                
                            //self.dismiss(animated: true, completion: nil)
                                
                                let emailNotSentAlert = UIAlertController(title: "Please Try Again", message: "One Or More Photos Not Saved", preferredStyle: .alert)
                                   emailNotSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                  self.present(emailNotSentAlert, animated: true, completion: nil)
                                
                                
                                print("Photos Not Acquired")
                                
                            } else {

                            thumbnail = result!
                                

                                    self.userSelectedimage(thumbnail)
                                self.PhotoArray.append(thumbnail)
                            }
                            
                    })
                    
                        
                }
            }
                self.collectionView.reloadData()
            }
        }
    
    
    
    
    @IBAction func selectImage(_ sender: Any) {
        
        
        let allAssets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
               var evenAssets = [PHAsset]()

               allAssets.enumerateObjects({ (asset, idx, stop) -> Void in
                   if idx % 2 == 0 {
                       evenAssets.append(asset)


                   }
               })

        // create an instance
        let imagePicker = BSImagePickerViewController()
        
        imagePicker.maxNumberOfSelections = 5



        

            self.SelectedAssets.removeAll()

             let start = Date()
             self.bs_presentImagePickerController(imagePicker, animated: true, select: { (asset) in


                print("Selected: \(asset)")

             }, deselect: { (asset) in



                 print("Deselected: \(asset)")

             }, cancel: { (assets) in



                 print("Canceled with selections: \(assets)")

             }, finish: { (assets) in


                for i in 0..<assets.count
                          {
                              self.SelectedAssets.append(assets[i])

                          }

                          self.getAllImg()


                 print("Finished with selections: \(assets)")
             }, completion: {
                 let finish = Date()
                 print(finish.timeIntervalSince(start))


             })
    }

    
    
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
picker.dismiss(animated: true, completion: nil)    }
    
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
            
            })
            } else {
            
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                
               userSelectedimage(image)
            }
            picker.dismiss(animated: true, completion: nil)

        }
}
    
}





