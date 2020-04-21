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
    @Published var selectedTeam: Team?
    @Published var teams: [Team] = []
    @Published var teamDict: [DocumentReference : Team] = [:]
    
    init() {
        fetchTeams()
    }
    
    func addDistrict(district: District) {
        //ref to team doc
        //        let teamDocRef = Firestore.firestore().collection("teams").document("2YRtIFLhYdTe7UNCvoVz")
        //make district file
        //        let dist = District(readyToInstall: true, numPreKSchools: 5, numElementarySchools: 5, numMiddleSchools: 5, numHighSchools: 5, districtContactPerson: "BOB", districtEmail: "Test@test.com", districtPhoneNumber: "555-555-5555", districtOfficeAddress: GeoPoint(latitude: 2, longitude: 2), team: teamDocRef, numPodsNeeded: 5, startDate: Date())
        //encode district file
        let districtData = try! FirestoreEncoder().encode(district)
        //send district file to database
        Firestore.firestore().collection("districts").document().setData(districtData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func fetchTeams() {
        teams = []
        Firestore.firestore().collection("districts").document("teams").getDocument { (document, error) in
            if let document = document, document.exists {
                if let teamArr = document.data()!["teams"] as? [DocumentReference] {
                    for docRef in teamArr {
                        docRef.getDocument { (teamDoc, teamError) in
                            let decodedTeamDoc = try! FirestoreDecoder().decode(Team.self, from: teamDoc?.data() ?? [:])
                            //                                resultArray.append(decodedTeamDoc)
                            self.teams.append(decodedTeamDoc)
                            self.teamDict[docRef] = decodedTeamDoc
//                            print("team dict")
//                            print(self.teamDict)
                        }
                    }
                } else {
                    print("error fetching team array")
                }
            }
            
        }
    }
}
