//
//  District.swift
//  KW Sales
//
//  Created by Luke Morse on 4/14/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//



import Foundation
import FirebaseFirestore
import CodableFirebase

struct District: Encodable {
    var districtID: String
    var districtName: String
    var readyToInstall: Bool
    var numPreKSchools: Int
    var numElementarySchools: Int
    var numMiddleSchools: Int
    var numHighSchools: Int
    var districtContactPerson: String
    var districtEmail: String
    var districtPhoneNumber: String
    var districtOfficeAddress: String
    var numPodsNeeded: Int
    var startDate: Date
    var implementationPlan: [Installation]
    
    init() {
        self.districtID = UUID().uuidString
        self.districtName = ""
        self.readyToInstall = false
        self.numPreKSchools = 0
        self.numElementarySchools = 0
        self.numMiddleSchools = 0
        self.numHighSchools = 0
        self.districtContactPerson = ""
        self.districtEmail = ""
        self.districtPhoneNumber = ""
        self.districtOfficeAddress = ""
        self.numPodsNeeded = 0
        self.startDate = Date()
        self.implementationPlan = []
    }

    private enum CodingKeys: String, CodingKey {
        case districtID
        case districtName
        case readyToInstall
        case numPreKSchools
        case numElementarySchools
        case numMiddleSchools
        case numHighSchools
        case districtContactPerson
        case districtEmail
        case districtPhoneNumber
        case districtOfficeAddress
        case numPodsNeeded
        case startDate
        case implementationPlan
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(districtID, forKey: .districtID)
        try container.encode(districtName, forKey: .districtName)
        try container.encode(readyToInstall, forKey: .readyToInstall)
        try container.encode(numPreKSchools, forKey: .numPreKSchools)
        try container.encode(numElementarySchools, forKey: .numElementarySchools)
        try container.encode(numMiddleSchools, forKey: .numMiddleSchools)
        try container.encode(numHighSchools, forKey: .numHighSchools)
        try container.encode(districtContactPerson, forKey: .districtContactPerson)
        try container.encode(districtEmail, forKey: .districtEmail)
        try container.encode(districtPhoneNumber, forKey: .districtPhoneNumber)
        try container.encode(districtOfficeAddress, forKey: .districtOfficeAddress)
        try container.encode(numPodsNeeded, forKey: .numPodsNeeded)
        try container.encode(Timestamp(date: startDate), forKey: .startDate)
        try container.encode(implementationPlan, forKey: .implementationPlan)
    }
}

extension District: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        districtID = try container.decode(String.self, forKey: .districtID)
        districtName = try container.decode(String.self, forKey: .districtName)
        readyToInstall = try container.decode(Bool.self, forKey: .readyToInstall)
        numPreKSchools = try container.decode(Int.self, forKey: .numPreKSchools)
        numElementarySchools = try container.decode(Int.self, forKey: .numElementarySchools)
        numMiddleSchools = try container.decode(Int.self, forKey: .numMiddleSchools)
        numHighSchools = try container.decode(Int.self, forKey: .numHighSchools)
        districtContactPerson = try container.decode(String.self, forKey: .districtContactPerson)
        districtEmail = try container.decode(String.self, forKey: .districtEmail)
        districtPhoneNumber = try container.decode(String.self, forKey: .districtPhoneNumber)
        districtOfficeAddress = try container.decode(String.self, forKey: .districtOfficeAddress)
        numPodsNeeded = try container.decode(Int.self, forKey: .numPodsNeeded)
        implementationPlan = try container.decode([Installation].self, forKey: .implementationPlan)
        
        let timeStamp: Timestamp = try container.decode(Timestamp.self, forKey: .startDate)
        startDate = timeStamp.dateValue()
    }
}
