//
//  File.swift
//  KW Sales
//
//  Created by Luke Morse on 4/14/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

struct Team: Encodable, Hashable, Identifiable {
    var id: Int { hashValue }
    
    var name: String
    let leader: User
    let members: [User]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(leader)
        hasher.combine(members)
    }
    
    init(name: String = "",
         leader: User = User(uid: "", name: "", email: "", phone: ""),
         members: [User] = [],
         installations: [Installation] = []) {
        self.name = name
        self.leader = leader
        self.members = members
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case leader
        case members
        case installations
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(leader, forKey: .leader)
        try container.encode(members, forKey: .members)
    }
}

extension Team: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        leader = try container.decode(User.self, forKey: .leader)
        members = try container.decode([User].self, forKey: .members)
    }
}
