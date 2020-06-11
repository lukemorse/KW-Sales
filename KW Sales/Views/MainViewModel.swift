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
    
    @Published var pendingDistrictNameDict: [String: String] = [:]
    @Published var completedDistrictNameDict: [String: String] = [:]
    @Published var addedByUserDistrictNameDict: [String: String] = [:]
    @Published var filteredDistrictNameDict: [String: String] = [:]
    @Published var filteredDistrictNames: [String] = []
    
    @Published var currentFilter: DistrictFilter = .noFilter
    private var installationViewModels: [String: [InstallationViewModel]] = [:]
    @Published var teams: [Team] = []
    @Published var numSchools = 0
    var currentUser = ""
    
    func fetchDistrict(docPath: String, completion: @escaping (District) -> Void) {
        let ref = Firestore.firestore().collection(Constants.kDistrictCollection).document(docPath)
        ref.getDocument { (document, error) in
            if let error = error {
                print(error)
            }
            if let document = document, document.exists {
                do {
                    let district = try FirebaseDecoder().decode(District.self, from: document.data() ?? District())
                    completion(district)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    //Networking
    func fetchDistrictList() {
        Firestore.firestore().collection(Constants.kPendingDistrictNameCollection).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    if let dict = document.data() as? [String:String] {
                        self.pendingDistrictNameDict = dict
                    }
                }
            }
        }
        
        Firestore.firestore().collection(Constants.kCompleteDistrictNameCollection).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    if let dict = document.data() as? [String:String] {
                        self.completedDistrictNameDict = dict
                    }
                }
            }
        }
        
        Firestore.firestore().collection(Constants.kAddedByUserDistrictNameCollection).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    if let dict = document.data() as? [String : [String:String]] {
                        if let currentUserDict = dict[self.currentUser] {
                            self.addedByUserDistrictNameDict = currentUserDict
                        }
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
                }
            }
        }
    }
//
//    func uploadDistrict(id: String, completion: @escaping (_ flag:Bool) -> ()) {
//        //encode district file
//        var districtIndex = 0
//        for (index,district) in districts.enumerated() {
//            if district.districtID == id {
//                districtIndex = index
//            }
//        }
//        var district = self.districts[districtIndex]
//        district.uploadedBy = currentUser
//        var implementationPlan: [Installation] = []
//        if installationViewModels.keys.contains(district.districtID) {
//            if installationViewModels[district.districtID]!.count > 0 {
//                for vm in installationViewModels[district.districtID]! {
//                    implementationPlan.append(vm.installation)
//                }
//            }
//            district.implementationPlan = implementationPlan
//        }
//
//        do {
//            let districtData = try FirestoreEncoder().encode(district)
//            //send district file to database
//            Firestore.firestore().collection(Constants.kDistrictCollection).document(district.districtName).setData(districtData) { error in
//                if let error = error {
//                    print("Error writing document: \(error)")
//                    completion(false)
//                } else {
//                    print("Document successfully written!")
//                    completion(true)
//                }
//            }
//        } catch let error {
//            print(error)
//            completion(false)
//        }
//    }
    
    //Edit District Info
//    func addDistrict() -> Binding<District> {
//        districts.append(District())
//        changeFilter(districtFilter: currentFilter)
//        let index = districts.count - 1
//        return Binding<District>(get: {return self.districts[index]}, set: {self.districts[index] = $0})
//    }
    
//    func getDistrict(id: String) -> Binding<District> {
//        for (index, district) in districts.enumerated() {
//            if district.districtID == id {
//                return Binding<District>(get: {return self.districts[index]}, set: {self.districts[index] = $0})
//            }
//        }
//        return .constant(District())
//    }
    
//    func getInstallationViewModels(for districtName: String) -> [InstallationViewModel] {
//        return self.installationViewModels[districtName] ?? []
//    }
    
//    func getInstallationViewModels(for districtID: String) -> [InstallationViewModel] {
//        for district in districts {
//            if district.districtID == districtID {
//                return self.installationViewModels[districtID] ?? []
//            }
//        }
//        return []
//    }
    
//    func setNumPods(numPods: Int, districtID: String) {
//        for (index, district) in districts.enumerated() {
//            if district.districtID == districtID {
//                districts[index].numPodsNeeded = numPods
//            }
//        }
//    }
//
//    func addInstallation(districtID: String) {
//        if let index = self.districts.firstIndex(where: {$0.districtID == districtID}) {
//            var installation = Installation()
//            installation.districtName = self.districts[index].districtName
//            installation.districtContact = self.districts[index].districtContactPerson
//            let viewModel = InstallationViewModel(installation: installation)
//
//            if installationViewModels.keys.contains(districtID) {
//                installationViewModels[self.districts[index].districtID]?.append(viewModel)
//            } else {
//                installationViewModels[self.districts[index].districtID] = [viewModel]
//            }
//            self.districts[index].implementationPlan.append(installation)
//        }
//    }
}

enum DistrictFilter {
    case noFilter, pending, complete, currentUser
}

extension MainViewModel {
    func changeFilter(districtFilter: DistrictFilter) {
        currentFilter = districtFilter
        
        switch districtFilter {
        case .noFilter:
            filteredDistrictNames = Array(pendingDistrictNameDict.values) + Array(completedDistrictNameDict.values) + Array(addedByUserDistrictNameDict.values)
            break
        case .pending:
            filteredDistrictNames = Array(pendingDistrictNameDict.values)
            break
        case .complete:
            filteredDistrictNames = Array(completedDistrictNameDict.values)
            break
        case .currentUser:
            filteredDistrictNames = Array(addedByUserDistrictNameDict.values)
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
