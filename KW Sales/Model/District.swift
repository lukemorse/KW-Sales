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

struct District: Codable {
    let readyToInstall: Bool
    let numPreKSchools: Int
    let numElementarySchools: Int
    let numMiddleSchools: Int
    let numHighSchools: Int
    let districtContactPerson: String
    let districtEmail: String
    let districtPhoneNumber: String
    let districtOfficeAddress: String
    let team: DocumentReference
    let numPodsNeeded: Int
    let startDate: Date
//
//    private enum CodingKeys: String, CodingKey {
//        case readyToInstall
//        case numPreKSchools
//        case numElementarySchools
//        case numMiddleSchools
//        case numHighSchools
//        case districtContactPerson
//        case districtEmail
//        case districtPhoneNumber
//        case districtOfficeAddress
//        case team
//        case numPodsNeeded
//        case startDate
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(readyToInstall, forKey: .readyToInstall)
//        try container.encode(numPreKSchools, forKey: .numPreKSchools)
//        try container.encode(numElementarySchools, forKey: .numElementarySchools)
//    }
}
//
//extension Installation: Decodable {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        statusCode = try container.decode(Int.self, forKey: .statusCode)
//        address = try container.decode(GeoPoint.self, forKey: .address)
//        districtContact = try container.decode(String.self, forKey: .districtContact)
//        districtName = try container.decode(String.self, forKey: .districtName)
//        schoolContact = try container.decode(String.self, forKey: .schoolContact)
//        schoolName = try container.decode(String.self, forKey: .schoolName)
//        email = try container.decode(String.self, forKey: .email)
//        numFloors = try container.decode(Int.self, forKey: .numFloors)
//        numRooms = try container.decode(Int.self, forKey: .numRooms)
//        numPods = try container.decode(Int.self, forKey: .numPods)
//        timeStamp = try container.decode(Timestamp.self, forKey: .timeStamp)
//    }
//}

//extension DocumentReference: DocumentReferenceType {}
//extension GeoPoint: GeoPointType {}
//extension FieldValue: FieldValueType {}
//extension Timestamp: TimestampType {}

