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
    @Published var implmentationPlanViews: [CreateInstallationView] = []
    @Published var numSchools = 0
    @Published var installationViewModels: [InstallationViewModel] = []
    
    func addInstallation() {
        let viewModel = InstallationViewModel(installation: Installation())
        self.implmentationPlanViews.append(CreateInstallationView(index: self.numSchools, viewModel: viewModel))
        installationViewModels.append(viewModel)
        self.numSchools += 1
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
