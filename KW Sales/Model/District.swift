//
//  District.swift
//  KW Sales
//
//  Created by Luke Morse on 4/14/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//



import Foundation
import Firebase
import CodableFirebase

struct District: Encodable {
    var districtID: String?
    var districtName: String?
    var readyToInstall: Bool?
    var numPreKSchools: Int?
    var numElementarySchools: Int?
    var numMiddleSchools: Int?
    var numHighSchools: Int?
    var districtContactPerson: String?
    var districtEmail: String?
    var districtPhoneNumber: String?
    var districtOfficeAddress: String?
    var team: Team?
    var numPodsNeeded: Int?
    var startDate: Date?
    var implementationPlan: [ImplementationPlanUnit]
    

    private enum CodingKeys: String, CodingKey {
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
        case team
        case numPodsNeeded
        case startDate
        case implementationPlan
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
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
        try container.encode(team, forKey: .team)
        try container.encode(numPodsNeeded, forKey: .numPodsNeeded)
        try container.encode(Timestamp(date: startDate ?? Date()), forKey: .startDate)
        try container.encode(implementationPlan, forKey: .implementationPlan)
    }
}

extension District: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        districtName = try container.decode(String.self, forKey: .districtName)
        readyToInstall = try container.decode(Bool.self, forKey: .readyToInstall)
        numPreKSchools = try container.decode(Int.self, forKey: .numPreKSchools)
        numElementarySchools = try container.decode(Int.self, forKey: .numElementarySchools)
        numMiddleSchools = try container.decode(Int.self, forKey: .numMiddleSchools)
        districtContactPerson = try container.decode(String.self, forKey: .districtContactPerson)
        districtEmail = try container.decode(String.self, forKey: .districtEmail)
        districtPhoneNumber = try container.decode(String.self, forKey: .districtPhoneNumber)
        districtOfficeAddress = try container.decode(String.self, forKey: .districtOfficeAddress)
        team = try container.decode(Team.self, forKey: .team)
        numPodsNeeded = try container.decode(Int.self, forKey: .numPodsNeeded)
        let timeStamp: Timestamp = try container.decode(Timestamp.self, forKey: .startDate)
        startDate = timeStamp.dateValue()
        implementationPlan = try container.decode([ImplementationPlanUnit].self, forKey: .implementationPlan)
    }
}

//extension DocumentReference: DocumentReferenceType {}
//extension GeoPoint: GeoPointType {}
//extension FieldValue: FieldValueType {}
//extension Timestamp: TimestampType {}

