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
    var installationDocRef: DocumentReference
    let url: URL
    @Published var pods: [Pod] = []
    
    init(installationDocRef: DocumentReference, url: URL) {
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
                    let podDict = try FirebaseDecoder().decode([String: Pod].self, from: document.data()!)
                    self.pods = Array(podDict.values)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func setPods(floorNum: Int, completion: @escaping (Bool) -> Void) {
        let podDocRef = installationDocRef.collection(Constants.kPodsSubCollection).document("\(floorNum)")
        do {
            var podDict: [String: Pod] = [:]
            for pod in pods {
                podDict[pod.uid] = pod
            }
            let data = try FirestoreEncoder().encode(podDict)
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
