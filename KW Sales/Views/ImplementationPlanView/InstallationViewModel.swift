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
    private var storageRef = Storage.storage().reference()
    private var floorPlanDocRef: DocumentReference?
    private(set) var installDocRef: DocumentReference
    private var listener: ListenerRegistration?
    
    init(installation: Installation, docRef: DocumentReference) {
        self.installation = installation
        self.installDocRef = docRef
    }
    
    func addStatusListener() {
        if listener == nil {
        self.listener = installDocRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            do {
                let install = try FirestoreDecoder().decode(Installation.self, from: data)
                self.installation.status = install.status
            }
            catch {
                print(error)
            }
        }
        }
    }
    
    func removeStatusListener() {
        listener?.remove()
    }
    
    public func uploadFloorPlan(image: UIImage, completion: @escaping (_ flag:Bool, _ url: String?) -> ()) {
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
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                
                let urlString = downloadURL.absoluteString
                self.addFloorplanURL(url: urlString)
                
                self.installation.floorPlanUrls.append(urlString)
                completion(true, urlString)
            }
        }
    }
    
    func addFloorplanURL(url: String) {
        installDocRef.updateData(["floorPlanURLs" : FieldValue.arrayUnion([url])]) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
}
