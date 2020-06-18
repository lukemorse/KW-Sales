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
    var installationDocRef: DocumentReference
    
    init(url: URL, installationDocRef: DocumentReference) {
        self.url = url
        self.installationDocRef = installationDocRef
    }
    
    func fetchPods(floorNum: Int) {
        let podDocRef = installationDocRef.collection(Constants.kPodsSubCollection).document("\(floorNum)")
        podDocRef.getDocument { (document, error) in
            if let error = error {
                print(error)
            }
            if let document = document, document.exists {
                do {
                    let podDict = try FirebaseDecoder().decode([String: [Pod]].self, from: document.data()!)
                    if let pods = podDict["pods"] {
                        self.pods = pods
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func setPods(floorNum: Int, completion: @escaping (Bool) -> Void) {
        let podDocRef = installationDocRef.collection(Constants.kPodsSubCollection).document("\(floorNum)")
        do {
            let data = try FirestoreEncoder().encode(["pods" : self.pods])
            podDocRef.setData(data) { error in
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
