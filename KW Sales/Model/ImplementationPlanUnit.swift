//
//  ImplementationPlanUnit.swift
//  KW Sales
//
//  Created by Luke Morse on 4/20/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//


import Foundation
import Firebase
import CodableFirebase

struct ImplementationPlanUnit: Codable {
    
    let id: String
    let schoolName: String
    let schoolType: SchoolType
    let numFloors: Int
    let numRooms: Int
    let numPods: Int
    let schoolContactPerson: String
    let podMaps: [PodMapModel]
}
