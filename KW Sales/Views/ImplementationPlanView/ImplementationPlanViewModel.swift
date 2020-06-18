//
//  ImplementationPlanViewModel.swift
//  KW Sales
//
//  Created by Luke Morse on 6/12/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

class ImplementationPlanViewModel: ObservableObject {
    @Published var installations: [Installation] = []
    var installationViewModels: [InstallationViewModel] = []
    let collectionRef: CollectionReference
    let districtID: String
    
    init(collectionRef: CollectionReference, districtID: String) {
//        self.collectionRef = collectionRef
        self.districtID = districtID
        self.collectionRef = Firestore.firestore().collection(Constants.kInstallSubCollection)
    }
    
    public func fetchInstallations() {
//        collectionRef.whereField("districtID", isEqualTo: districtID).
        collectionRef.whereField("districtID", isEqualTo: districtID).getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
            }
            for document in snapshot!.documents {
                do {
                    let install = try FirestoreDecoder().decode(Installation.self, from: document.data())
                    self.installations.append(install)
                    let docRef = self.collectionRef.document(install.installationID)
                    let vm = InstallationViewModel(installation: install, docRef: docRef)
                    self.installationViewModels.append(vm)
                    
                } catch {
                    print(error)
                }
            }
        }
    }
    
    public func addInstallation() {
        let install = Installation(districtID: districtID)
        let docRef = self.collectionRef.document(install.installationID)
        let vm = InstallationViewModel(installation: install, docRef: docRef)
        self.installationViewModels.append(vm)
        self.installations.append(install)
    }
    
    public func saveImplementationPlan(completion: @escaping (Bool) -> ()) {
        for vm in installationViewModels {
            let install = vm.installation
            do {
                let data = try FirestoreEncoder().encode(install)
                collectionRef.document(install.installationID).setData(data) { (error) in
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
    
}
