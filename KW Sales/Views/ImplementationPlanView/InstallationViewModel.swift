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
import SwiftUI

class InstallationViewModel: ObservableObject {
    @Published var installation: Installation
    @Published var address: String
    @Published var teams: [Team]
    @Published var teamIndex = 0
    @Published var floorPlanImages: [Image] = []
    var docRef: DocumentReference?
    var childKeys: [String] = []
    
    init(installation: Installation, teams: [Team]) {
        self.installation = installation
        self.address = ""
        self.teams = teams
    }

    func uploadFloorPlan(image: UIImage, index: Int = 0, completion: @escaping (_ flag:Bool) -> ()) {
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
                
                let urlString = url.absoluteString
                self.installation.floorPlanUrls.append(urlString)
                
                let data = [
                    "imageURL": urlString,
                    ]
                
                if let parentDocRef = self.docRef {
                    parentDocRef.setData(data, merge: true) { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                            completion(false)
                            return
                        }
                        completion(true)
                        print("successfully added image to database")
                    }
                }
            }
        }
    }
    
}
