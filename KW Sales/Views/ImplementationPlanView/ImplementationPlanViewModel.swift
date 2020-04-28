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

class ImplementationPlanViewModel: ObservableObject {
    @Published var implmentationPlanViews: [InstallationView] = []
    @Published var numSchools = 0
    @Published var installationViewModels: [InstallationViewModel] = []
    var districtName: String = ""
    var districtContactPerson: String = ""
    var districtEmail: String = ""
    var schoolContact: String = ""
    
    func addInstallation() {
        var installation = Installation()
        installation.districtName = self.districtName
        installation.districtContact = self.districtContactPerson
        let viewModel = InstallationViewModel(installation: installation)
        self.implmentationPlanViews.append(InstallationView(index: self.numSchools, viewModel: viewModel))
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
        let dict = [self.districtName : getInstallations()]
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
