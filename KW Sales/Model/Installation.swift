//
//  Installation.swift
//  KW Sales
//
//  Created by Luke Morse on 4/23/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

struct Installation: Encodable, Identifiable, Hashable  {
    static func == (lhs: Installation, rhs: Installation) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int {hashValue}
    var statusCode: Int
    var schoolType: SchoolType
    var address: GeoPoint
    var districtContact: String
    var districtName: String
    var schoolContact: String
    var schoolName: String
    var email: String
    var numFloors: Int
    var numRooms: Int
    var numPods: Int
    var timeStamp: Timestamp
    var podMaps: [PodMapModel]
    
    private enum CodingKeys: String, CodingKey {
        
        case statusCode
        case schoolType
        case address
        case districtContact
        case districtName
        case schoolContact
        case schoolName
        case email
        case numFloors
        case numRooms
        case numPods
        case timeStamp
        case podMaps
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(statusCode, forKey: .statusCode)
        try container.encode(schoolType.description, forKey: .schoolType)
        try container.encode(address, forKey: .address)
        try container.encode(districtContact, forKey: .districtContact)
        try container.encode(districtName, forKey: .districtName)
        try container.encode(schoolContact, forKey: .schoolContact)
        try container.encode(schoolName, forKey: .schoolName)
        try container.encode(email, forKey: .email)
        try container.encode(numFloors, forKey: .numFloors)
        try container.encode(numRooms, forKey: .numRooms)
        try container.encode(numPods, forKey: .numPods)
        try container.encode(timeStamp, forKey: .timeStamp)
        try container.encode(podMaps, forKey: .podMaps)
    }
}

extension Installation: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try container.decode(Int.self, forKey: .statusCode)
        schoolType = try container.decode(SchoolType.self, forKey: .schoolType)
        address = try container.decode(GeoPoint.self, forKey: .address)
        districtContact = try container.decode(String.self, forKey: .districtContact)
        districtName = try container.decode(String.self, forKey: .districtName)
        schoolContact = try container.decode(String.self, forKey: .schoolContact)
        schoolName = try container.decode(String.self, forKey: .schoolName)
        email = try container.decode(String.self, forKey: .email)
        numFloors = try container.decode(Int.self, forKey: .numFloors)
        numRooms = try container.decode(Int.self, forKey: .numRooms)
        numPods = try container.decode(Int.self, forKey: .numPods)
        timeStamp = try container.decode(Timestamp.self, forKey: .timeStamp)
        podMaps = try container.decode([PodMapModel].self, forKey: .podMaps)
    }
}

extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}
