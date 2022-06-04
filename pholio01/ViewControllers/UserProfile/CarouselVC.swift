//
//  3DLocationsVC.swift
//  pholio01
//
//  Created by Chris  Ransom on 3/23/22.
//  Copyright © 2022 Chris Ransom. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseStorage

    func degreeToRadians(degree: CGFloat) -> CGFloat {
        return (degree * CGFloat.pi)/180
    }

    class CarouselVC: UIViewController {
        
        var ref = Database.database().reference()

        let Model: String = "Gateway Arch Park"
        let Kiener: String = "Kiener Plaza Park"
        let Garden: String = "City Garden"
        let Grove: String = "Tower Grove Park"
        let Art: String = "Art Hill"
        
        let transfromLayer = CATransformLayer()
        var currentAngle: CGFloat = 0
        var currentOffset: CGFloat = 0
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = UIColor.white
            
            transfromLayer.frame = self.view.bounds
            view.layer.addSublayer(transfromLayer)
            
            
    if Auth.auth().currentUser != nil {
        DBService.shared.users.child(Auth.auth().currentUser!.uid).child("Locations").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            
        if snapshot.exists(){
               print("User Signed In")
            
            // Add all images from assets
            for i in 1...5 {
                self.addImage(name: "\(i)")
            }
            
            
    //    self.postToken(Token: token)
           //p;il  =-=-0v9self.ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("notificationTokens").updateChildValues(token)

                
        } else if snapshot.value as! NSObject ==  DBService.shared.users.child(Auth.auth().currentUser!.uid).child("Locations").child(self.Kiener) {
               
               // Add all images from assets
               for i in 6...10{
                   self.addImage(name: "\(i)")
               }
               

            }
           
                    })
                }
            
            turnCarousel()
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CarouselVC.performAction(recognizer:)))
            view.addGestureRecognizer(panGestureRecognizer)
            
        }
        
        // Light Style
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
       
        func addImage(name: String) {
            
            let imageCardSize = CGSize(width: 200, height: 300)
            let imageLayer = CALayer()
            imageLayer.frame = CGRect(x: view.frame.size.width / 2 - imageCardSize.width / 2 , y: view.frame.size.height / 2 - imageCardSize.height / 2, width: imageCardSize.width, height: imageCardSize.height)
            
            imageLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            guard let imageCardImage = UIImage(named: name)?.cgImage else { return }
            
            imageLayer.contents = imageCardImage
            imageLayer.contentsGravity = .resizeAspectFill
            imageLayer.masksToBounds = true
            imageLayer.isDoubleSided = true
            
            imageLayer.borderColor = UIColor(white: 1, alpha: 1.0).cgColor
            imageLayer.borderWidth = 5
            imageLayer.cornerRadius = 10
            
            transfromLayer.addSublayer(imageLayer)
            
        }
        
        func turnCarousel() {
            guard let transformSubLayers = transfromLayer.sublayers else { return }
            
            let segmentForImageCard = CGFloat(360 / transformSubLayers.count)
            
            var angleOffset = currentAngle
            
            for layer in transformSubLayers {
                var transform = CATransform3DIdentity
                transform.m34 = -1 / 500
                
                transform = CATransform3DRotate(transform, degreeToRadians(degree: angleOffset), 0, 1, 0)
                transform = CATransform3DTranslate(transform, 0, 0, 200)
                
                CATransaction.setAnimationDuration(0)
                
                angleOffset += segmentForImageCard
                
                layer.transform = transform
            }
            
            
            
        }
        
        
        @objc func performAction(recognizer: UIPanGestureRecognizer) {
            
            
            let xOffset = recognizer.translation(in: self.view).x
            
            if recognizer.state == .began {
                currentOffset = 0
            }
            
            let xDifference = xOffset * 0.6 - currentOffset
            
            currentOffset += xDifference
            currentAngle += xDifference
            
            turnCarousel()
            
        }
        
    }
