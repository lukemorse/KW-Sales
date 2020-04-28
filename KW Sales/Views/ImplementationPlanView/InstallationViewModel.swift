//
//  CreateImplementationPlanViewModel.swift
//  KW Sales
//
//  Created by Luke Morse on 4/20/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

class InstallationViewModel: ObservableObject {
    @Published var installation: Installation
//    var docRef: DocumentReference?
    var docRef: DocumentReference?
    var childKeys: [String] = []
    
    init(installation: Installation) {
        self.installation = installation
    }

    func uploadFloorPlan(image: UIImage, index: Int = 0) {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            print("could not create data from image")
            return
        }
        let uuid = UUID().uuidString
        let imageRef = Storage.storage().reference().child(Constants.kFloorPlanFolder).child(uuid)
        imageRef.putData(data, metadata: nil) { (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    print(error.localizedDescription)
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
                
                
                
//                print("doc id: \(docRef.documentID)")
                
                let urlString = url.absoluteString
                
                self.installation.podMaps.append(PodMapModel(id: UUID().uuidString, pods: [:]))
                self.installation.podMaps[index].imageUrl = urlString
                
                let childKey = UUID().uuidString
                self.childKeys.append(childKey)
                
                let data = [childKey : [
                    "uid": String(self.installation.id),
                    "imageURL": urlString,
                    "pods" : ""
                    ]]
                
                if let parentDocRef = self.docRef {
                    parentDocRef.setData(data, merge: true) { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        print("successfully added image to database")
                    }
                }
            }
        }
    }
    
    func updatePodMaps(atIndex index: Int) {
        let podMap = self.installation.podMaps[index]
        if let parentDocRef = self.docRef {
            parentDocRef.updateData([childKeys[index] :["pods" : podMap.pods]]) { (err) in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                    print("successfully updated pods")
                }
            }
        }
            
        
    }
 
}
