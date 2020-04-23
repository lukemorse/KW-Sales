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
    @Published var teamDict: [DocumentReference : Team] = [:]
    @Published var district: District?
//    var districtName: String?
    
    init() {
        self.district = District(districtID: nil, readyToInstall: nil, numPreKSchools: nil, numElementarySchools: nil, numMiddleSchools: nil, numHighSchools: nil, districtContactPerson: nil, districtEmail: nil, districtPhoneNumber: nil, districtOfficeAddress: nil, team: nil, numPodsNeeded: nil, startDate: nil, implementationPlan: [])
        fetchTeams()
    }
    
    func uploadDistrict() {
        if let district = self.district {
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
    }
    
    func importCSV() {
        let arr = parseCSV()
        district?.numPodsNeeded = Int(arr[0]) ?? 0
        let dateString = arr[1]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        district?.startDate = dateFormatter.date(from: dateString) ?? Date()
        
        district?.districtName = arr[2]
        district?.numPreKSchools = Int(arr[3]) ?? 0
        district?.numElementarySchools = Int(arr[4]) ?? 0
        district?.numMiddleSchools = Int(arr[5]) ?? 0
        district?.numHighSchools = Int(arr[6]) ?? 0
        district?.districtContactPerson = arr[7]
        district?.districtEmail = arr[8]
        district?.districtPhoneNumber = arr[9]
        district?.districtOfficeAddress = String(arr[10].dropLast())
    }
    
    func fetchTeams() {
        teams = []
        Firestore.firestore().collection(Constants.kDistrictCollection).document(Constants.kTeamCollection).getDocument { (document, error) in
            if let document = document, document.exists {
                if let teamArr = document.data()!["teams"] as? [DocumentReference] {
                    for docRef in teamArr {
                        docRef.getDocument { (teamDoc, teamError) in
                            let decodedTeamDoc = try! FirestoreDecoder().decode(Team.self, from: teamDoc?.data() ?? [:])
                            self.teams.append(decodedTeamDoc)
                            self.teamDict[docRef] = decodedTeamDoc
                        }
                    }
                } else {
                    print("error fetching team array")
                }
            }
            
        }
    }
}
