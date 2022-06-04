//
//  PhotoShootTableVC.swift
//  pholio01
//
//  Created by Chris  Ransom on 9/15/21.
//  Copyright © 2021 Chris Ransom. All rights reserved.
//


import UIKit
import AVFoundation
import AVKit
import Firebase
import CTSlidingUpPanel
import Cosmos
import Firebase
import FirebaseAuth
import Kingfisher
import SwiftUI
import Lottie
import iCarousel

private let dateFormatter: DateFormatter = {
    print("I JUST CREATED A DATE FORMATTER")
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
    
    
}()






class PhotoShootTableVC: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, iCarouselDelegate, iCarouselDataSource {
   
    
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    
    @IBOutlet weak var locationBtn: UIButton!
    
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var notes: UITextView!
    
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var compactDatePicker: UIDatePicker!
    
    @IBOutlet weak var courseCollectionView: UICollectionView!
        
    @IBOutlet var bottomSheet: UIView!
    @IBOutlet weak var iCarousel: iCarousel!
    
    
    struct Storyboard {
      
        static let showDetailVC = "ShowImageDetail"
  
    }
    
    
    var profilevc: ProfileVC!
    var toDoItem: ToDoItem!
    //var selectedImage: String!
    var courses = Course.FetchCourse()
    var cellScale : CGFloat = 0.6
    var selectedimage: UIImage!
    var ref = Database.database().reference()
    
    var LocationImages = [
        UIImage(named: "1"),
        UIImage(named: "2"),
        UIImage(named: "3"),
        UIImage(named: "4"),
        UIImage(named: "5"),
    
    ]

    let userID = Auth.auth().currentUser?.uid
    let datePickerIndex = IndexPath(row: 1, section: 1)
    let notesTextViewIndexPath = IndexPath(row: 0, section: 2)
    let notesRowHeaight = 450
    let defaultRowHeight = 50
    let local: String = "Location TBD"
    let Model: String = "Gateway Arch Park"
    let Kiener: String = "Kiener Plaza Park"
    let Garden: String = "City Garden"
    let Grove: String = "Tower Grove Park"
    let Art: String = "Art Hill"

    
    
    
    
    let locationImages = [
        
        UIImage(named: "location1a"),
        UIImage(named: "location2a"),
        UIImage(named: "location3a"),
        UIImage(named: "location4a"),
        UIImage(named: "location5a"),
    
    ]
    
    let locationNames = [
        
         "Gateway Arch Park",
         "Kiener Plaza Park",
         "City Garden",
         "Tower Grove Park",
         "Art Hill, Forest Park",
    
    ]
   
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        view.addSubview(visualEffectView)
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        visualEffectView.alpha = 0
        
        
        bottomSheet.frame = CGRect(x: 0, y: 600, width: bottomSheet.frame.size.width, height: bottomSheet.frame.size.height )
        
        UIView.animate(withDuration: 0.6) {
            

            self.view.transform = .identity
        }
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragged(gestureRecognizer:)))
        bottomSheet.isUserInteractionEnabled = true
        bottomSheet.addGestureRecognizer(panGesture)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("Photoshoot Location").updateChildValues(["Photoshoot Location": local])

        
        let postRef = ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("Photoshoot Location")
        
        postRef.observe(.childChanged, with: { (snapshot) -> Void in
            
            self.navigationController?.navigationBar.layer.zPosition = 0
            self.bottomSheet.removeFromSuperview()
            print("Did remove pop up view..")
            
        })
        
        iCarousel.type = .rotary
        iCarousel.contentMode = .scaleAspectFit
        courseCollectionView.dataSource = self
        courseCollectionView.delegate = self
//
//             let screenSize = UIScreen.main.bounds.size
//             let cellWidth = floor(screenSize.width * cellScale )
//             let cellHeight = floor(screenSize.height * cellScale)
//             let instX = ( view.bounds.width - cellWidth ) / 9.0
//             let instY = ( view.bounds.height - cellHeight ) / 9.0
//             let layout = courseCollectionView!.collectionViewLayout as! UICollectionViewFlowLayout
//
//             layout.itemSize = CGSize(width: 325, height: 370 )
//             courseCollectionView.contentInset = UIEdgeInsets(top: instY , left: instX , bottom: instY, right: instX )
//             courseCollectionView.dataSource = self
//
    
        

        bottomSheet.layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
        bottomSheet.layer.borderWidth = 1.5
        bottomSheet.layer.cornerRadius = 32
        bottomSheet.clipsToBounds = true

        bottomSheet.layer.shadowColor = UIColor.black.cgColor
        bottomSheet.layer.shadowOpacity = 0
        bottomSheet.layer.shadowOffset = .zero
        bottomSheet.layer.shadowRadius = 0
        
        //show or hide the appropriate date picker
        
        
        if #available(iOS 14.0, *) {
            
            self.datePicker = self.compactDatePicker
            self.datePicker.isHidden = false
            self.dateLabel.isHidden = false
            
            
        }  else  {
            
            self.datePicker = self.compactDatePicker
            self.dateLabel.isHidden = false
        }
            
        
        
        
        // setup foreground notification
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        
        
        
        //hide keybpard if we tap outside of a field
        let  tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        textField.delegate = self
        
        if toDoItem == nil {
            
            toDoItem = ToDoItem(name: "", date: Date(), notes:"", reminderSet: false, completed: false)
            textField.becomeFirstResponder()
            }
        updateUserInterface()
        
    }

    
    @objc func appActiveNotification() {
        print("App in foreground")
        updateReminderSwitch()
        
    }
    
    @objc func dragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {

            let translation = gestureRecognizer.translation(in: self.view)
            print(gestureRecognizer.view!.center.y)

            if(gestureRecognizer.view!.center.y > 400 ) {

                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x, y: gestureRecognizer.view!.center.y + translation.y)

            } else {
                gestureRecognizer.view!.center = CGPoint(x:gestureRecognizer.view!.center.x, y:405)
            }
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        }
        
        if gestureRecognizer.state == .ended {
            
            if(gestureRecognizer.view!.center.y > 500 ) {

                UIView.animate(withDuration: 0.75, animations: {
                    
                    self.navigationController?.navigationBar.layer.zPosition = 0

                 
                    self.bottomSheet.removeFromSuperview()
                    print("Did remove pop up window..")
    
                }

            )} else {
                gestureRecognizer.view!.center = CGPoint(x:gestureRecognizer.view!.center.x, y:405)
            }

            
            
        }
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        LocationImages.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        var imageView: UIImageView!
        if view == nil {
            
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 75, height: self.view.frame.size.height ))
            
            imageView.contentMode = .scaleAspectFit
            
        } else {
            
            imageView = view as? UIImageView
        }
        
        
        
        imageView.image = LocationImages[index]
        return imageView
        
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LocationsCell
        
        cell.locationImage.image = locationImages[indexPath.row]
        cell.locationNames.text =  locationNames[indexPath.row]
        
        cell.button.tag = indexPath.row
      cell.button.addTarget(self, action: #selector(checkBoxTapped), for: UIControl.Event.touchUpInside)
       
        
        //This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = cell.contentView.frame.size.height / 3
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 1, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
        return cell
    }
    
  
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        
      
        let index = [sender.tag] as IndexPath
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
            
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
        }) { (success) in
            
            sender.isSelected = !sender.isSelected
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                sender.transform = .identity
                
                if index == [0] {
                    
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let alertVC = sb.instantiateViewController(identifier: "LocationAlertVC") as! LocationAlertVC
                    alertVC.modalPresentationStyle = .overCurrentContext
                    self.present(alertVC, animated: true, completion: nil)
                    
                    print(index)
                    

                } else  if index == [1] {
                    
                    print(index)

                } else  if index == [2] {
                    
                    print(index)

                    
                } else  if index == [3] {
                    
                    print(index)

                    
                    
                } else  if index == [4] {
                    
                    print(index)
                    
                }
                
                            
            }, completion: nil)
            
        }
        
        
        
        /*if sender.isSelected {
           sender.isSelected = false
        } else {
            sender.isSelected  = true
        }*/
    }
    
    @IBAction func clickedOnButton(_ sender: Any) {
        
        
        
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: [], //options: nil
            animations: ({

                self.view.addSubview(self.bottomSheet)

                self.bottomSheet.center.y = self.view.frame.width / 3

                self.bottomSheet.frame = CGRect(x: 0, y: -40, width: self.bottomSheet.frame.size.width, height: self.bottomSheet.frame.size.height )
                
                
                self.visualEffectView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height )

            
            self.bottomSheet.isUserInteractionEnabled = true

            self.navigationController?.navigationBar.layer.zPosition = -1

                
                self.bottomSheet.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)

                
            }), completion: nil)

    }
    
    func updateUserInterface() {
        
        textField.text = toDoItem.name
        datePicker.date = toDoItem.date
        notes.text = toDoItem.notes
        reminderSwitch.isOn = toDoItem.reminderSet
        dateLabel.textColor = (reminderSwitch.isOn ? .black : .gray)
        dateLabel.text = dateFormatter.string(from: toDoItem.date)
        datePicker.isEnabled = reminderSwitch.isOn
        enableDisableSaveButton(text: textField.text!)
        updateReminderSwitch()
        

    }
    
    func updateReminderSwitch() {
        
        LocalNotificationManager.isAuthorized { (authorized) in
            
            DispatchQueue.main.async {
                
                
                if !authorized && self.reminderSwitch.isOn {
                    
                    self.oneButtonAlert(title: "User Has Not Allowed Notifications", message: "To receive alerts for reminders, open the Settings app, select PHOLLIO > Notifications > Allow Notifications")
                    self.reminderSwitch.isOn = false
                }
                self.view.endEditing(true)
                self.dateLabel.textColor = (self.reminderSwitch.isOn ? .black : .gray)
                self.datePicker.isEnabled = self.reminderSwitch.isOn
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        toDoItem = ToDoItem(name: textField.text!, date: datePicker.date, notes:  notes.text, reminderSet: reminderSwitch.isOn,  completed: toDoItem.completed)
    }
    
    
    func enableDisableSaveButton(text: String){
        
        if text.count > 0 {
            
            saveBarButton.isEnabled = true
        } else {
            
            saveBarButton.isEnabled = false
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            
            dismiss(animated: true, completion: nil)

           // navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func reminderSwitchChanged(_ sender: UISwitch) {
     updateReminderSwitch()
    }
    
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        
        dateLabel.text = dateFormatter.string(from: sender.date)
        self.view.endEditing(true)
    }
    
    @IBAction func textFieldEditedChanged(_ sender: UITextField) {
        enableDisableSaveButton(text: sender.text!)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        selectedimage =  locationImages[indexPath.row]
//        performSegue(withIdentifier: Storyboard.showDetailVC, sender: nil)
        
        switch indexPath.row {
                case 0:
            performSegue(withIdentifier: "CarouselVC", sender: self)
            

            let childupdates: [String: Any] = [
                "/Gateway": Model,
        ]
            
            let userRef = ref.child("Users").child(Auth.auth().currentUser!.uid)
            userRef.child("Locations").updateChildValues(["Location": "Arch"])
            print("Shoot Location Tapped! 00")
            

                case 1:
            performSegue(withIdentifier: "CarouselVC", sender: self)

            
            
            let childupdates: [String: Any] = [
                "/Kiener": Kiener,
        ]
            
            let userRef = ref.child("Users").child(Auth.auth().currentUser!.uid)
            userRef.child("Locations").updateChildValues(["Location": "Kiener"])
            print("Shoot Location Tapped! 01")
            
                case 2:
            performSegue(withIdentifier: "CarouselVC", sender: self)

            
            let childupdates: [String: Any] = [
                "/Garden": Garden,
        ]
            
            let userRef = ref.child("Users").child(Auth.auth().currentUser!.uid)
            userRef.updateChildValues(childupdates)
            print("Shoot Location Tapped! 02")
            
                case 3:
            performSegue(withIdentifier: "CarouselVC", sender: self)

            
            let childupdates: [String: Any] = [
                "/Grove": Grove,
        ]
            
            let userRef = ref.child("Users").child(Auth.auth().currentUser!.uid)
            userRef.updateChildValues(childupdates)
            print("Shoot Location Tapped! 03")
            
                case 4:
            performSegue(withIdentifier: "CarouselVC", sender: self)

            
            let childupdates: [String: Any] = [
                "/Art6": Art,
        ]
            
            let userRef = ref.child("Users").child(Auth.auth().currentUser!.uid)
            userRef.updateChildValues(childupdates)
            print("Shoot Location Tapped! 04")

              default:
            print("Shoot Location Tapped!")

              }
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
   

  
}

extension PhotoShootTableVC {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        let headerHeight: CGFloat

        switch section {
        case 0:
            // hide the header
//            headerHeight = CGFloat.leastNonzeroMagnitude
            headerHeight = 30

        
        default:
            headerHeight = 30
        }

        return headerHeight
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndex:

            if #available(iOS 14.0, *) {
                return 0
            } else {
                return reminderSwitch.isOn ? datePicker.frame.height : 0
            }
        case notesTextViewIndexPath:
            return CGFloat(notesRowHeaight)


        default:
            return CGFloat(defaultRowHeight)
        }
    }



}

extension PhotoShootTableVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        notes.becomeFirstResponder()
        return true
    }
}
