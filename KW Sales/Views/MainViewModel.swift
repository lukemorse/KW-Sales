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
    @Published var districtList: [District] = []
    @Published var currentFilter: DistrictFilter = .noFilter
    @Published var teams: [Team] = []
    @Published var numSchools = 0
    var currentUser = ""
    
    //Networking
    func fetchDistricts() {
        let ref = Firestore.firestore().collection(Constants.kDistrictCollection)
        var query: Query
        
        switch self.currentFilter {
        case .noFilter:
            query = ref.limit(to: 10)
            break
        case .currentUser:
            query = ref.whereField("uploadedBy", isEqualTo: currentUser)
        case .complete:
            query = ref.whereField("status", isEqualTo: DistrictStatus.complete)
        case .pending:
            query = ref.whereField("status", isEqualTo: DistrictStatus.pending)
        }
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
            } else {
                for document in snapshot!.documents {
                    do {
                        let district = try FirestoreDecoder().decode(District.self, from: document.data())
                        self.districtList.append(district)
                    } catch {
                        print(error)
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
    
    func changeFilter(districtFilter: DistrictFilter) {
        currentFilter = districtFilter
        fetchDistricts()
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
