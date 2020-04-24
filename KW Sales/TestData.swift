//
//  TestData.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import Firebase

let testInstallStatus0 = Installation(statusCode: 0, schoolType: .elementary, address: GeoPoint(latitude: 2, longitude: 2), districtContact: "", districtName: "", schoolContact: "", schoolName: "School x", email: "", numFloors: 4, numRooms: 3, numPods: 4, timeStamp: Timestamp(date: Date()), podMaps: [])

let testInstallStatus1 = Installation(statusCode: 1, schoolType: .elementary, address: chicagoGeoPoint, districtContact: "", districtName: "", schoolContact: "", schoolName: "", email: "", numFloors: 0, numRooms: 0, numPods: 0, timeStamp: Timestamp(), podMaps: [])

let testInstallStatus2 = Installation(statusCode: 2, schoolType: .elementary, address: chicagoGeoPoint, districtContact: "", districtName: "", schoolContact: "", schoolName: "", email: "", numFloors: 0, numRooms: 0, numPods: 0, timeStamp: Timestamp(), podMaps: [])

let testInstallArray = [testInstallStatus0,testInstallStatus0,testInstallStatus0,testInstallStatus1,testInstallStatus1,testInstallStatus1,testInstallStatus2,testInstallStatus0,testInstallStatus2]

let chicagoGeoPoint = GeoPoint(latitude: 41.8781, longitude: -87.6298)
