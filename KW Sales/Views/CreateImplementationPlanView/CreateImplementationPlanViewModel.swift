//
//  CreateImplementationPlanViewModel.swift
//  KW Sales
//
//  Created by Luke Morse on 4/20/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import Firebase
import CodableFirebase

class CreateImplementationPlanViewModel: ObservableObject {
    @Published var podMaps: [PodMapModel] = []
    @Published var implementationPlanUnits: [ImplementationPlanUnit] = []
    
    func uploadFloorPlan(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            print("could not create data from image")
            return
        }
        let imageName = UUID().uuidString
        let imageRef = Storage.storage().reference().child(Constants.kFloorPlanFolder).child(imageName)
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
                let data = [
                    "uid": docID,
                    "imageURL": urlString
                ]
                
                let podMapModel = PodMapModel(id: docID, pods: [[:]])
                self.podMaps.append(podMapModel)
                
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
    
    func uploadImplementationPlan(implemenationPlans: [ImplementationPlanUnit]) {
        //encode district file
        self.implementationPlanUnits = implemenationPlans
        print(implemenationPlans)
        let dict = ["districtName?" ?? "" :implemenationPlans]
        let implementationPlanData = try! FirestoreEncoder().encode(dict)
        //send district file to database
        Firestore.firestore().collection(Constants.kImplementationPlanCollection).document().setData(implementationPlanData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func updateFloorPlanPods(atIndex index: Int) {
        let podMap = podMaps[index]
        let dataRef = Firestore.firestore().collection(Constants.kFloorPlanCollection).document(podMap.id)
        let data = [
            "id" : podMap.id,
            "pods": podMap.pods
            ] as [String : Any]
        dataRef.setData(data) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("successfully updated floor plan pods")
        }
    }
 
}
