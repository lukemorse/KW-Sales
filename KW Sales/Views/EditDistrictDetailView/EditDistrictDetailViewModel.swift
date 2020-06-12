//
//  EditDistrictDetailViewModel.swift
//  KW Sales
//
//  Created by Luke Morse on 6/11/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

class EditDistrictDetailViewModel: ObservableObject {
    private var docRef: DocumentReference
    @Published var district = District()
    
    init(docPath: String) {
        self.docRef = Firestore.firestore().collection(Constants.kDistrictCollection).document(docPath)
    }
    
    func fetchDistrictData(docPath: String, completion: @escaping (District) -> Void) {
        docRef.getDocument { (document, error) in
            if let error = error {
                print(error)
            }
            if let document = document, document.exists {
                do {
                    let district = try FirebaseDecoder().decode(District.self, from: document.data()!)
                    completion(district)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func uploadDistrict(completion: @escaping (Bool) -> Void) {
        do {
            let districtData = try FirestoreEncoder().encode(self.district)
            let dict = [self.district.districtID: self.district.districtName]
            
            let batch = Firestore.firestore().batch()
            batch.setData(districtData, forDocument: docRef)
            batch.setData(dict, forDocument: Firestore.firestore().collection(Constants.kCompleteDistrictNameCollection).document())
            batch.commit { (error) in
                if let error = error {
                    print(error)
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } catch {
            print(error)
            
        }
    }
}
