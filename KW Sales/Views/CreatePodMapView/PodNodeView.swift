//
//  PodNodeView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/16/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct PodNodeView: Identifiable, Hashable, Equatable, View {
    
    var podType: PodType
    var id: Int { hashValue }
    var uuid = UUID()
    var pos: CGPoint
    @State private var position = CGSize.zero
    
    static func == (lhs: PodNodeView, rhs: PodNodeView) -> Bool {
        return lhs.id == rhs.id && lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    var body: some View {
        Image(podImageDict[self.podType] ?? "")
            .resizable()
            .frame(width: 30, height: 30)
            .position(pos)
            .colorMultiply(Color.red)
    }
}

enum PodType: Int, Codable, CaseIterable, Hashable, Identifiable {
    var id: Int { hashValue }
    
    case outdoor, corner, hallway, ceiling
    
    var description: String {
        switch self {
        case .outdoor:
            return "outdoor"
        case .corner:
            return "corner"
        case .hallway:
            return "hallway"
        case .ceiling:
            return "ceiling"
        }
    }
}


let podImageDict: [PodType : String] = [
    .outdoor : "outdoor pod",
    .corner : "corner pod",
    .hallway : "hallway pod",
    .ceiling : "ceiling pod"
]

struct PodNodeView_Previews: PreviewProvider {
    static var previews: some View {
        PodNodeView(podType: .hallway, pos: CGPoint(x: 250, y: 250))
    }
}
