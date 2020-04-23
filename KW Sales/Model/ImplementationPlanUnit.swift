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
    
    let id = UUID().uuidString
    var schoolName: String
    var schoolType: SchoolType
    var numFloors: Int
    var numRooms: Int
    var numPods: Int
    var schoolContactPerson: String
    var podMaps: [PodMapModel]
}
