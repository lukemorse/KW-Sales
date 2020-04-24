//
//  ImplementationPlanViewModel.swift
//  KW Sales
//
//  Created by Luke Morse on 4/22/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//


import Foundation
import Firebase
import CodableFirebase

class ImplementationPlanListViewModel: ObservableObject {
    @Published var installations: [Installation] = []
    var installationViewModels: [InstallationViewModel] = []
    
    func addInstallation() -> InstallationViewModel {
        let installation = Installation(status: .notStarted, schoolType: .elementary, address: chicagoGeoPoint, districtContact: "", districtName: "", schoolContact: "", schoolName: "", email: "", numFloors: 0, numRooms: 0, numPods: 0, timeStamp: Timestamp(), podMaps: [])
        let viewModel = InstallationViewModel(installation: installation)
        installations.append(installation)
        installationViewModels.append(viewModel)
        return viewModel
    }
    
    func getInstallations() -> [Installation] {
        var result: [Installation] = []
        for viewModel in installationViewModels {
            result.append(viewModel.installation)
        }
        return result
    }
    
    func uploadImplementationPlan() {
        //encode district file
        let dict = ["districtName?" : getInstallations()]
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
 
}
