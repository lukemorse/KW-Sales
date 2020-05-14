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
            .scaledToFit()
            .frame(
                width: self.podType == .horizontal_hallway ? 25 : 15,
                height: self.podType == .vertical_hallway ? 25 : 15)
            .position(pos)
            .colorMultiply(Color.red)
    }
}

enum PodType: Int, Codable, CaseIterable, Hashable, Identifiable {
    var id: Int { hashValue }
    
    case outdoor, corner, horizontal_hallway, vertical_hallway
    
    var description: String {
        switch self {
        case .outdoor:
            return "outdoor"
        case .corner:
            return "corner"
        case .horizontal_hallway:
            return "hallway"
        case .vertical_hallway:
            return "vertical hallway"
        }
    }
}


let podImageDict: [PodType : String] = [
    .outdoor : "outdoor pod",
    .corner : "corner pod",
    .horizontal_hallway : "horizontal hallway pod",
    .vertical_hallway : "vertical hallway pod"
]

struct PodNodeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PodNodeView(podType: .horizontal_hallway, pos: CGPoint(x: 250, y: 250))
            PodNodeView(podType: .vertical_hallway, pos: CGPoint(x: 250, y: 250))
            PodNodeView(podType: .outdoor, pos: CGPoint(x: 250, y: 250))
        }
        
    }
}
