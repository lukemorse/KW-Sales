//
//  PodMapModel.swift
//  KW Sales
//
//  Created by Luke Morse on 4/20/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import Firebase
import CodableFirebase

struct PodMapModel: Codable, Hashable {
    
    let uid: String
    var pods: [String : [String : [Float]]]
    var imageUrl: String = ""
    
    enum CodingKeys: String, CodingKey {
        case uid
        case pods
        case imageUrl
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(pods, forKey: .pods)
        try container.encode(imageUrl, forKey: .imageUrl)
    }
}
