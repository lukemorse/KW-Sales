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
    var implementationPlanListViewModel: ImplementationPlanViewModel?
    @Published var district = District()
    @Published var numPodsString = ""
    
    
    func uploadDistrict(completion: @escaping (_ flag:Bool) -> ()) {
        if let implementationPlanListViewModel = self.implementationPlanListViewModel {
            district.implementationPlan = implementationPlanListViewModel.getInstallations()
        }
        //encode district file
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
//        district.districtOfficeAddress = String(arr[10].dropLast())
    }
}
