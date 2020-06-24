//
//  Pod.swift
//  KW Sales
//
//  Created by Luke Morse on 4/29/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

import Foundation
import Firebase
import CodableFirebase

struct Pod: Encodable, Hashable, Identifiable {
    var id: Int { hashValue }
    let podType: PodType
    var xMul: Float
    var yMul: Float
    var imageUrl: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(podType)
        hasher.combine(xMul)
        hasher.combine(yMul)
        hasher.combine(imageUrl)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case podType
        case xMul
        case yMul
        case imageUrl
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(podType, forKey: .podType)
        try container.encode(xMul, forKey: .xMul)
        try container.encode(yMul, forKey: .yMul)
        try container.encode(imageUrl, forKey: .imageUrl)
    }
}

extension Pod: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        podType = try container.decode(PodType.self, forKey: .podType)
        xMul = try container.decode(Float.self, forKey: .xMul)
        yMul = try container.decode(Float.self, forKey: .yMul)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
    }
}

