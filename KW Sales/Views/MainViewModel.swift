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
    @Published var filteredDistricts: [District] = []
    @Published var currentFilter = 0
    @Published var teams: [Team] = []
    @Published var numSchools = 0
    var currentUser = ""
    private var installationViewModels: [String: [InstallationViewModel]] = [:]
    
    //Networking
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
                self.filteredDistricts = self.districts
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
                    print(team.name)
                    self.teams.append(team)
                }
            }
        }
    }
    
    func uploadDistrict(districtIndex: Int, completion: @escaping (_ flag:Bool) -> ()) {
        //encode district file
        var district = self.districts[districtIndex]
        district.uploadedBy = currentUser
        var implementationPlan: [Installation] = []
        if installationViewModels.keys.contains(district.districtName) {
            if installationViewModels[district.districtName]!.count > 0 {
                for vm in installationViewModels[district.districtName]! {
                    implementationPlan.append(vm.installation)
                }
            }
            district.implementationPlan = implementationPlan
        }
        
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
    
    //Edit District Info
    func addDistrict() -> Binding<District> {
        districts.append(District())
        changeFilter(filterIndex: currentFilter)
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
    
    func setNumPods(numPods: Int, districtIndex: Int) {
        districts[districtIndex].numPodsNeeded = numPods
    }
}

extension MainViewModel {
    //filters:
    //0 = pending
    //1 = complete
    //2 = current user added
    //3 = remove filter/show all
    func changeFilter(filterIndex: Int) {
        filteredDistricts = []
        currentFilter = filterIndex
        switch filterIndex {
        case 0:
            filteredDistricts = districts
        case 1:
            for district in districts {
                for installation in district.implementationPlan {
                    if installation.status == .inProgress {
                        filteredDistricts.append(district)
                        break
                    }
                }
            }
            break
        case 2:
            var add = false
            for district in districts {
                for installation in district.implementationPlan {
                    if installation.status != .complete {
                        add = false
                    }
                }
                if add {
                    filteredDistricts.append(district)
                    add = false
                }
            }
            break
        case 3:
            for district in districts {
                //replace with user check
                if district.uploadedBy == self.currentUser {
                    filteredDistricts.append(district)
                    break
                }
            }
            break
        default:
            break
        }
    }
}

//SAVE FOR MAC APP
//func importCSV() {
//        let arr = parseCSV()
//        district.numPodsNeeded = Int(arr[0]) ?? 0
//        let dateString = arr[1]
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .long
//        dateFormatter.timeStyle = .none
//        district.startDate = dateFormatter.date(from: dateString) ?? Date()
//
//        district.districtName = arr[2]
//        district.numPreKSchools = Int(arr[3]) ?? 0
//        district.numElementarySchools = Int(arr[4]) ?? 0
//        district.numMiddleSchools = Int(arr[5]) ?? 0
//        district.numHighSchools = Int(arr[6]) ?? 0
//        district.districtContactPerson = arr[7]
//        district.districtEmail = arr[8]
//        district.districtPhoneNumber = arr[9]
////        district.districtOfficeAddress = String(arr[10].dropLast())
//    }
