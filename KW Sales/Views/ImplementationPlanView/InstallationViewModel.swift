//
//  CreateImplementationPlanViewModel.swift
//  KW Sales
//
//  Created by Luke Morse on 4/20/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import CodableFirebase
import SwiftUI

class InstallationViewModel: ObservableObject {
    @Published var installation: Installation
//    @Published var floorPlanImages: [Image] = []
    
    var storageRef: StorageReference
    var docRef: DocumentReference?
    
    init(installation: Installation) {
        self.installation = installation
        self.storageRef = Storage.storage().reference()
    }
    
//    func downloadFloorplans() {
//        if installation.floorPlanUrls.count > floorPlanImages.count {
//            for url in installation.floorPlanUrls {
//                Storage.storage().reference(forURL: url).getData(maxSize: INT64_MAX) { (data, error) in
//                    if let error = error {
//                        print(error.localizedDescription)
//                        return
//                    }
//                    DispatchQueue.main.async {
//                        let image = Image(uiImage: UIImage(data: data!)!)
//                        self.floorPlanImages.append(image)
//                    }
//                }
//            }
//        }
//    }
    
//    func downloadFloorplans() {
//        if installation.floorPlanUrls.count > floorPlanImages.count {
//            for url in installation.floorPlanUrls {
//                let image = AsyncImage(url: URL(string: url)!)
//                self.floorPlanImages.append(image)
//            }
//        }
//    }

    func uploadFloorPlan(image: UIImage, completion: @escaping (_ flag:Bool, _ url: String?) -> ()) {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            print("could not create data from image")
            return
        }
        let uuid = UUID().uuidString
        let imageRef = Storage.storage().reference().child(Constants.kFloorPlanFolder).child(uuid)
        imageRef.putData(data, metadata: nil) { (metaData, error) in
            if let error = error {
                print(error)
                return
            }
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard let url = url else {
                    print("could not create url")
                    return
                }
                
                //if this is the first floorplan for the installation, make a new folder
                if self.docRef == nil {
                    let docID = String(self.installation.id)
                    self.docRef = Firestore.firestore().collection(Constants.kFloorPlanCollection).document(docID)
                }
                
                let urlString = url.absoluteString
                
                let data = [
                    "imageURL": urlString,
                    ]
                
                if let parentDocRef = self.docRef {
                    parentDocRef.setData(data, merge: true) { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                            completion(false, nil)
                            return
                        }
                        completion(true, urlString)
                        self.installation.floorPlanUrls.append(urlString)
                        print("successfully added image to database")
                    }
                }
            }
        }
    }
    
}
