//
//  TestData.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import Firebase

let testInstallStatus0 = Installation(statusCode: 0, schoolType: .elementary, address: GeoPoint(latitude: 2, longitude: 2), districtContact: "", districtName: "", schoolContact: "", schoolName: "School x", email: "", numFloors: 4, numRooms: 3, numPods: 4, timeStamp: Timestamp(date: Date()))

let testInstallStatus1 = Installation(statusCode: 1, schoolType: .highSchool, address: GeoPoint(latitude: 2, longitude: 2), districtContact: "", districtName: "", schoolContact: "", schoolName: "School x", email: "", numFloors: 4, numRooms: 3, numPods: 4, timeStamp: Timestamp(date: Date()))

let testInstallStatus2 = Installation(statusCode: 2, schoolType: .middleSchool, address: GeoPoint(latitude: 2, longitude: 2), districtContact: "", districtName: "", schoolContact: "", schoolName: "School x", email: "", numFloors: 4, numRooms: 3, numPods: 4, timeStamp: Timestamp(date: Date()))

let testInstallArray = [testInstallStatus0,testInstallStatus0,testInstallStatus0,testInstallStatus1,testInstallStatus1,testInstallStatus1,testInstallStatus2,testInstallStatus0,testInstallStatus2]


