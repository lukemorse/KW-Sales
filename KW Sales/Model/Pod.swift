//
//  Pod.swift
//  KW Sales
//
//  Created by Luke Morse on 4/29/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

struct Pod: Encodable, Hashable, Identifiable {
    var id: Int { hashValue }
    let podType: PodType
    var position: CGPoint
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(position.x)
        hasher.combine(position.y)
        hasher.combine(podType)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case podType
        case position
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(podType, forKey: .podType)
        try container.encode(position, forKey: .position)
    }
}

extension Pod: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        podType = try container.decode(PodType.self, forKey: .podType)
        position = try container.decode(CGPoint.self, forKey: .position)
    }
}
