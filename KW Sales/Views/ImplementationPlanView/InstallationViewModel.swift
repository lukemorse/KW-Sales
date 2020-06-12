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
    
    private var storageRef: StorageReference
    private var installDocRef: DocumentReference
    private var floorPlanDocRef: DocumentReference?
    
    init(docId: String) {
        self.storageRef = Storage.storage().reference()
        self.installDocRef = Firestore.firestore().collection(Constants.kFloorPlanCollection).document(docId)
        self.installation = Installation()
    }
    
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
                if self.floorPlanDocRef == nil {
                    let docID = String(self.installation.id)
                    self.floorPlanDocRef = Firestore.firestore().collection(Constants.kFloorPlanCollection).document(docID)
                }
                
                let urlString = url.absoluteString
                let data = ["imageURL": urlString]
                
                if let docRef = self.floorPlanDocRef {
                    docRef.setData(data, merge: true) { (error) in
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
    
    func fetchInstallation(docId: String) {
        self.installDocRef.getDocument { (document, error) in
            if let error = error {
                print(error)
            }
            if let document = document, document.exists {
                do {
                    let installation = try FirebaseDecoder().decode(Installation.self, from: document.data()!)
                    self.installation = installation
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func setInstallation() {
        do {
            let data = try FirestoreEncoder().encode(self.installation)
            self.installDocRef.setData(data) {error in
                if let error = error {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
}
