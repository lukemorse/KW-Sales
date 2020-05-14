//
//  ImplementationPlanViewModel.swift
//  KW Sales
//
//  Created by Luke Morse on 4/22/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//


import Foundation
import FirebaseFirestore
import CodableFirebase

class ImplementationPlanViewModel: ObservableObject {
    @Published var implmentationPlanViews: [InstallationView] = []
    @Published var numSchools = 0
    @Published var installationViewModels: [InstallationViewModel] = []
    @Published var teams: [Team] = []
    
    var districtName: String = ""
    var districtContactPerson: String = ""
    var districtEmail: String = ""
    var schoolContact: String = ""
    
    init() {
        fetchTeams()
    }
    
    private func fetchTeams() {
        teams = []
        Firestore.firestore().collection(Constants.kTeamCollection).getDocuments() { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                for document in snapshot!.documents {
                    let team = try! FirestoreDecoder().decode(Team.self, from: document.data())
                    self.teams.append(team)
                    print(team)
                }
            }
        }
    }
    
    func addInstallation() {
        var installation = Installation()
        installation.districtName = self.districtName
        installation.districtContact = self.districtContactPerson
        let viewModel = InstallationViewModel(installation: installation, teams: self.teams)
        self.implmentationPlanViews.append(InstallationView(index: self.numSchools, viewModel: viewModel, locationSearchService: LocationSearchService()))
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
