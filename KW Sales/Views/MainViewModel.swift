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
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var districts: [District] = []
    @Published var teams: [Team] = []
    @Published var numSchools = 0
    private var installationViewModels: [String: [InstallationViewModel]] = [:]
    
    func addDistrict() -> Binding<District> {
        districts.append(District())
        let index = districts.count - 1
        return Binding<District>(get: {return self.districts[index]}, set: {self.districts[index] = $0})
    }
    
    func getDistrict(index: Int) -> Binding<District> {
        return Binding<District>(get: {return self.districts[index]}, set: {self.districts[index] = $0})
    }
    
    func getInstallationViewModels(for districtName: String) -> [InstallationViewModel] {
        if self.installationViewModels.keys.contains(districtName) {
           return self.installationViewModels[districtName]!
        }
        return []
    }
    
    func fetchDistricts() {
        districts = []
        Firestore.firestore().collection(Constants.kDistrictCollection).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    do {
                        let district = try FirestoreDecoder().decode(District.self, from: document.data())
                        self.districts.append(district)
                        //get implementation plan
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
    
    func addInstallation(districtName: String) {
        if let index = self.districts.firstIndex(where: {$0.districtName == districtName}) {
            var installation = Installation()
            installation.districtName = self.districts[index].districtName
            installation.districtContact = self.districts[index].districtContactPerson
            let viewModel = InstallationViewModel(installation: installation)

            if installationViewModels.keys.contains(self.districts[index].districtName) {
                installationViewModels[self.districts[index].districtName]?.append(viewModel)
            } else {
                installationViewModels[self.districts[index].districtName] = [viewModel]
            }
            self.districts[index].implementationPlan.append(installation)
        }
        
    }
    
    func uploadDistrict(districtIndex: Int, completion: @escaping (_ flag:Bool) -> ()) {
    //        if let implementationPlanListViewModel = self.implementationPlanListViewModel {
    //            district.implementationPlan = implementationPlanListViewModel.getInstallations()
    //        }
            //encode district file
        var district = self.districts[districtIndex]
        var implementationPlan: [Installation] = []
        if installationViewModels.keys.contains(district.districtName) {
            if installationViewModels[district.districtName]!.count > 0 {
                for vm in installationViewModels[district.districtName]! {
                    implementationPlan.append(vm.installation)
                }
            }
        }
        
        district.implementationPlan = implementationPlan
            do {
                let districtData = try FirestoreEncoder().encode(district)
                //send district file to database
                Firestore.firestore().collection(Constants.kDistrictCollection).document(district.districtName).setData(districtData) { error in
                    if let error = error {
                        print("Error writing document: \(error)")
                        completion(false)
                    } else {
                        print("Document successfully written!")
                        completion(true)
                    }
                }
            } catch let error {
                print(error)
                completion(false)
            }
            
        }
    
}
