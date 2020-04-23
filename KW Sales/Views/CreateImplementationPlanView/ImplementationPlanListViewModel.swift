//
//  ImplementationPlanViewModel.swift
//  KW Sales
//
//  Created by Luke Morse on 4/22/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//


import Foundation
import Firebase
import CodableFirebase

class ImplementationPlanListViewModel: ObservableObject {
    @Published var implementationPlanUnits: [ImplementationPlanUnit] = []
    var implementationPlanUnitViewModels: [ImplementationPlanUnitViewModel] = []
    
    func addImplementationPlanUnit() -> ImplementationPlanUnitViewModel {
        let implementationPlanUnit = ImplementationPlanUnit(schoolName: "", schoolType: .elementary, numFloors: 0, numRooms: 0, numPods: 0, schoolContactPerson: "", podMaps: [])
        let viewModel = ImplementationPlanUnitViewModel(implementationPlanUnit: implementationPlanUnit)
        implementationPlanUnits.append(implementationPlanUnit)
        implementationPlanUnitViewModels.append(viewModel)
        return viewModel
    }
    
    func getImplementationPlanUnits() -> [ImplementationPlanUnit] {
        var result: [ImplementationPlanUnit] = []
        for viewModel in implementationPlanUnitViewModels {
            result.append(viewModel.implementationPlanUnit)
        }
        return result
    }
    
    func uploadImplementationPlan() {
        //encode district file
        let dict = ["districtName?" ?? "" : getImplementationPlanUnits()]
        let implementationPlanData = try! FirestoreEncoder().encode(dict)
        //send district file to database
        Firestore.firestore().collection(Constants.kImplementationPlanCollection).document().setData(implementationPlanData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
 
}
