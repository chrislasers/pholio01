////
////  Spots.swift
////  Snacktacular
////
////  Created by John Gallaugher on 6/12/20.
////  Copyright © 2020 John Gallaugher. All rights reserved.
////
//
//import Foundation
//import Firebase
//
//class Spots {
//    var spotArray: [UserModel] = []
//    var db: Firestore!
//    let userID = Auth.auth().currentUser?.uid
//
//    
//    init() {
//        db = Firestore.firestore()
//    }
//    
//    func loadImagesData() {
//        let db = Firestore.firestore()
//        let partyRef = db.collection("parties").document(userID!)
//
//        partyRef.addSnapshotListener() { (snapshot, err) in
//            if let err = err {
//               print("An error occurred: \(err.localizedDescription)")
//            } else {
//               let photoSharingImages = snapshot?.data()?["photo_sharing_images"] as? [String] ?? [String]()
//
//               for photoSharingImage in photoSharingImages {
//                   guard let url = URL(string: photoSharingImage) else {
//                   print("Unable to retrieve URL from photo sharing image URL.")
//                   return
//               }
//
//                let photo = UserModel(
//                self.photos.append(photo)
//             }
//
//             print("These are the URL from the array: \(photoSharingImages)")
//         }
//    }
//    }
//
//    
//    func loadData(completed: @escaping () -> ()) {
//        db.collection("spots").addSnapshotListener { (querySnapshot, error) in
//            guard error == nil else {
//                print("😡 ERROR: adding the snapshot listener \(error!.localizedDescription)")
//                return completed()
//            }
//            self.spotArray = [] // clean out existing spotArray since new data will load
//            // there are querySnapshot!.documents.count documents in the snapshot
//            for document in querySnapshot!.documents {
//                // You'll have to maek sure you have a dictionary initializer in the singular class
//                let spot = Spot(dictionary: document.data())
//                spot.documentID = document.documentID
//                self.spotArray.append(spot)
//            }
//            completed()
//        }
//    }
//}
