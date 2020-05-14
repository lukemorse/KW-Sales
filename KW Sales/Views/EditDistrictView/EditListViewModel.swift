//
//  EditListViewModel.swift
//  KW Sales
//
//  Created by Luke Morse on 5/14/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

class EditListViewModel: ObservableObject {
    @Published var districts: [District] = []
    
    func getDistricts() {
        self.districts = []
        Firestore.firestore().collection(Constants.kDistrictCollection).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    do {
                        let district = try FirestoreDecoder().decode(District.self, from: document.data())
                        self.districts.append(district)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
