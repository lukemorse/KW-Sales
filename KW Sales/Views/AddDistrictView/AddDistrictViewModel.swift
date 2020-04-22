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
    @Published var teamDict: [DocumentReference : Team] = [:]
    var districtName: String?
    
    init() {
        fetchTeams()
    }
    
    func addDistrict(district: District) {
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
