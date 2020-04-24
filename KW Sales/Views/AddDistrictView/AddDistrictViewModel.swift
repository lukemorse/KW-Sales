//
//  AddDistrictViewModel.swift
//  KW Sales
//
//  Created by Luke Morse on 4/14/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

class AddDistrictViewModel: ObservableObject {
    @Published var teams: [Team] = []
    @Published var teamIndex = 0
    @Published var district = District()
    
    init() {
        fetchTeams()
    }
    
    func addInstallation(installation: Installation) {
        district.implementationPlan.append(installation)
    }
    
    func uploadDistrict() {
        //encode district file
        let districtData = try! FirestoreEncoder().encode(district)
        //send district file to database
        Firestore.firestore().collection(Constants.kDistrictCollection).document().setData(districtData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    func importCSV() {
        let arr = parseCSV()
        district.numPodsNeeded = Int(arr[0]) ?? 0
        let dateString = arr[1]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        district.startDate = dateFormatter.date(from: dateString) ?? Date()
        
        district.districtName = arr[2]
        district.numPreKSchools = Int(arr[3]) ?? 0
        district.numElementarySchools = Int(arr[4]) ?? 0
        district.numMiddleSchools = Int(arr[5]) ?? 0
        district.numHighSchools = Int(arr[6]) ?? 0
        district.districtContactPerson = arr[7]
        district.districtEmail = arr[8]
        district.districtPhoneNumber = arr[9]
        district.districtOfficeAddress = String(arr[10].dropLast())
    }
    
    func fetchTeams() {
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
}
