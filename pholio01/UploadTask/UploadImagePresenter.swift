//
//  UploadImagePresenter.swift
//  pholio01
//
//  Created by Chris  Ransom on 6/3/18.
//  Copyright © 2018 Chris Ransom. All rights reserved.
//

import UIKit


protocol UploadImagesPresenterDelegate: AnyObject {
    
    func uploadImagesPresenterDidScrollTo(index: Int)
}

class UploadImagePresenter: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UIActionSheetDelegate {
    
    var images: [Any] = []
    var selectedImage: UIImage!

    
    func add(image: UIImage)  {
        
        images.append(image)

    }
    

    
    weak var delegate: UploadImagesPresenterDelegate?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let offset = scrollView.contentOffset.x
        
        if offset <= 0 {
            delegate?.uploadImagesPresenterDidScrollTo(index: 0)
        } else {
            let pageIndex = offset/pageWidth
            delegate?.uploadImagesPresenterDidScrollTo(index: Int(pageIndex))
        }
    }


    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UploadimageCell
        
        let image = images[indexPath.item]
        cell.fill(with: image as! UIImage)
        
        
        return cell

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }

    func collectionView(_ collection: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexpath: IndexPath) -> CGSize {

        let size = UIScreen.main.bounds
        return CGSize(width: (size.width/3)-3, height: (size.height/3)-3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

       //gallery.deselectItem(at: indexPath, animated: true)
        // selectedImage =  (images[indexPath.item] as! UIImage)

        
        //1. Delete photo from data source
        images.remove(at: indexPath.item)
                      
        //2. Delete photo from collectionview table
        collectionView.deleteItems(at: [indexPath])
        


       print("You Deleted Me")
        print(indexPath.item)
        
   }
    
    
}




extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
//
    func collectionView(_ collection: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexpath: IndexPath) -> CGSize {

        let size = UIScreen.main.bounds
        return CGSize(width: (size.width/3)-3, height: (size.height/3)-3)
    }
}

extension SelectImageVC: UploadimageCellDelgate {
    
    
    func delete(cell: UploadimageCell) {
        if let indexPath = collectionView?.indexPath(for: cell) {
            
            //1. Delete photo from data source
            images.remove(at: indexPath.item)
                          
            //2. Delete photo from collectionview table
                          collectionView?.deleteItems(at: [indexPath])
                          
        }
    }
    
    
    
}

