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
                let dataRef = Firestore.firestore().collection(Constants.kFloorPlanCollection).document()
                let docID = dataRef.documentID
                let urlString = url.absoluteString
                
                self.installation.podMaps.append(PodMapModel(id: docID, pods: [:]))
                self.installation.podMaps[index].imageUrl = urlString
                
                let data = [
                    "uid": docID,
                    "imageURL": urlString,
                    "pods" : ""
                    ]
                
                dataRef.setData(data) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    print("successfully added image to database")
                }
            }
        }
    }
    
    func updatePodMaps(atIndex index: Int) {
        let podMap = self.installation.podMaps[index]
        let dataRef = Firestore.firestore().collection(Constants.kFloorPlanCollection).document(podMap.id)
        
        dataRef.updateData(["pods" : podMap.pods]) { (err) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                print("successfully updated pods")
            }
        }
    }
 
}
