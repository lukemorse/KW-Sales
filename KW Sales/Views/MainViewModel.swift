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
import Combine

class MainViewModel: ObservableObject {
    @Published var districtList: [District] = []
    @Published var currentFilter: DistrictFilter = .noFilter
    @Published var teams: [Team] = []
    @Published var numSchools = 0
    @Published var searchText = ""
    
    var cancellable: AnyCancellable?
    
    var currentUser = ""
    let districtsRef = Firestore.firestore().collection(Constants.kDistrictCollection)
    
    init() {
        cancellable = $searchText
        .removeDuplicates()
            .debounce(for: 0.8, scheduler: DispatchQueue.main)
            .sink { str in
                self.fetchDistricts()
        }
    }
    
    //Networking
    
    func fetchDistricts() {
        
        var query: Query
       
        switch self.currentFilter {
        case .noFilter:
            query = districtsRef.limit(to: 10)
            break
        case .currentUser:
            query = districtsRef.whereField("uploadedBy", isEqualTo: currentUser).limit(to: 10)
        case .complete:
            query = districtsRef.whereField("status", isEqualTo: DistrictStatus.complete.rawValue).limit(to: 10)
        case .pending:
            query = districtsRef.whereField("status", isEqualTo: DistrictStatus.pending.rawValue).limit(to: 10)
        }
        
        if !searchText.isEmpty {
            query = query.whereField("districtName", isGreaterThanOrEqualTo: searchText).whereField("districtName", isLessThanOrEqualTo: searchText + "~")
        }
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
            } else {
                self.districtList = []
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
        if districtFilter != currentFilter {
            currentFilter = districtFilter
            fetchDistricts()
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
