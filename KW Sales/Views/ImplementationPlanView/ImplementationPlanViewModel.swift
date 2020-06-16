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
    @Published var installationViewModels: [InstallationViewModel] = []
    let collectionRef: CollectionReference
    
    init(collectionRef: CollectionReference) {
        self.collectionRef = collectionRef
    }
    
    public func fetchInstallations() {
        collectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
            }
            for document in snapshot!.documents {
                do {
                    let install = try FirestoreDecoder().decode(Installation.self, from: document.data())
                    self.installations.append(install)
                    let vm = InstallationViewModel(implementationPlanCollectionRef: self.collectionRef, installation: install)
                    self.installationViewModels.append(vm)
                    
                } catch {
                    print(error)
                }
            }
        }
    }
    
    public func addInstallation() {
        let install = Installation()
        let vm = InstallationViewModel(implementationPlanCollectionRef: self.collectionRef, installation: install)
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
