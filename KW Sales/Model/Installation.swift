//
//  Installation.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.


import Foundation
import Firebase
import CodableFirebase

struct Installation: Encodable, Hashable {
    let statusCode: Int
    let address: GeoPoint
    let districtContact: String
    let districtName: String
    let schoolContact: String
    let schoolName: String
    let email: String
    let numFloors: Int
    let numRooms: Int
    let numPods: Int
    let timeStamp: Timestamp
    
    private enum CodingKeys: String, CodingKey {
        case statusCode
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
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(statusCode, forKey: .statusCode)
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
    }
}

extension Installation: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try container.decode(Int.self, forKey: .statusCode)
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
    }
}

extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}
