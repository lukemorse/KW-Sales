//
//  MainViewModel.swift
//  KW Sales
//
//  Created by Luke Morse on 5/15/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

class MainViewModel: ObservableObject {
    @Published var districts: [District] = []
    @Published var teams: [Team] = []
    @Published var numSchools = 0
    @Published var installationViewModels: [String: [InstallationViewModel]] = [:]
    
    func getDistricts() {
        districts = []
        Firestore.firestore().collection(Constants.kDistrictCollection).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    do {
                        let district = try FirestoreDecoder().decode(District.self, from: document.data())
                        self.districts.append(district)
                        
                        for installation in district.implementationPlan {
                            let viewModel = InstallationViewModel(installation: installation)
                            if self.installationViewModels.keys.contains(district.districtName) {
                                self.installationViewModels[district.districtName]?.append(viewModel)
                            } else {
                                self.installationViewModels[district.districtName] = [viewModel]
                            }
                        }
                        
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func fetchTeams() {
        self.teams = []
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
    
    func addInstallation(index: Int) {
        var installation = Installation()
        installation.districtName = self.districts[index].districtName
        installation.districtContact = self.districts[index].districtContactPerson
        let viewModel = InstallationViewModel(installation: installation)

        if installationViewModels.keys.contains(self.districts[index].districtName) {
            installationViewModels[self.districts[index].districtName]?.append(viewModel)
        } else {
            installationViewModels[self.districts[index].districtName] = [viewModel]
        }
    }
    
}
