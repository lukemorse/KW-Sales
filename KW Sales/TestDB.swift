//
//  TestDB.swift
//  KW SalesTests
//
//  Created by Luke Morse on 5/19/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import Firebase

struct TestDB {
    static var testInstallation1: Installation {
        var result = Installation(districtID: "TestDistrictID")
//        result.address = GeoPoint(latitude: 44, longitude: 19)
        result.address = ""
        result.teamName = "Test Team"
        result.status = .notStarted
        result.schoolType = .elementary
        result.districtContact = "Jerry"
        result.districtName = "District 1"
        result.schoolContact = "Veronica"
        result.schoolName = "Happy School"
        result.email = "email@email.com"
        result.numFloors = 7
        result.numRooms = 13
        result.numPods = 200
        result.date = Date()
        result.floorPlanUrls = []
        return result
    }
    
    static var testInstallation2: Installation {
        var result = Installation(districtID: "TestDistrictID")
        result.address = ""
        result.teamName = "Test Team"
        result.status = .complete
        result.schoolType = .elementary
        result.districtContact = "Jerry"
        result.districtName = "District 1"
        result.schoolContact = "Veronica"
        result.schoolName = "Fun School"
        result.email = "email@email.com"
        result.numFloors = 7
        result.numRooms = 13
        result.numPods = 200
        result.date = Date()
        result.floorPlanUrls = []
        return result
    }
    
    static var district1: District {
        var result = District()
        result.districtContactPerson = "afe"
        result.districtID = UUID().uuidString
        result.districtName = "Test District 1"
        result.readyToInstall = true
        result.numPreKSchools = 5
        result.numElementarySchools = 5
        result.numMiddleSchools = 5
        result.numHighSchools = 5
        result.districtContactPerson = "Jonathan"
        result.districtEmail = "Jonathan@test.com"
        result.districtPhoneNumber = "555-123-4413"
        result.districtOfficeAddress = ""
        result.numPodsNeeded = 150
        result.startDate = Date()
//        result.implementationPlan = [testInstallation1,testInstallation2]
        return result
    }
}

