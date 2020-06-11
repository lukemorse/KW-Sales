//
//  PodMapViewModel.swift
//  KW Sales
//
//  Created by Luke Morse on 6/11/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

class PodMapViewModel: ObservableObject {
    let url: URL
    var pods: [Pod] = []
    var docRef: DocumentReference
    
    init(url: URL) {
        self.url = url
        self.docRef = Firestore.firestore().collection(Constants.kDistrictCollection).document(url.absoluteString)
    }
    
    func fetchPods() {
        docRef.getDocument { (document, error) in
            if let error = error {
                print(error)
            }
            if let document = document, document.exists {
                do {
                    let pods = try FirebaseDecoder().decode([Pod].self, from: document.data()!)
                    self.pods = pods
                } catch {
                    print(error)
                }
            }
        }
    }
}
