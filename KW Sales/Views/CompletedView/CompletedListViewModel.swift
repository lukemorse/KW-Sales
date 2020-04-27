//
//  CompletedListViewModel.swift
//  KW Sales
//
//  Created by Luke Morse on 4/23/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

class CompletedListViewModel: ObservableObject {
    @Published var districts: [District] = []
    
    func getDistrictsWithCompletedSchools() {
        districts = []
        Firestore.firestore().collection(Constants.kDistrictCollection).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    let district = try! FirestoreDecoder().decode(District.self, from: document.data())
                    var shouldAdd = false
                    for school in district.implementationPlan {
                        if school.status == .complete {
                            shouldAdd = true
                        }
                    }
                    if shouldAdd {
                        self.districts.append(district)
                        shouldAdd = false
                    }
                    
                }
            }
        }
    }
 
}
