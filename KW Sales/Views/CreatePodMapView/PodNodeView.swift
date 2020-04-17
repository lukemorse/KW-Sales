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
    @State var isActive: Bool
    @GestureState private var dragOffset = CGSize.zero
    @State private var position = CGSize.zero
    
    static func == (lhs: PodNodeView, rhs: PodNodeView) -> Bool {
        return lhs.id == rhs.id && lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(isActive)
        hasher.combine(uuid)
    }
    
    var body: some View {
        if isActive {
            return AnyView(Image(podImageDict[self.podType] ?? "")
                .resizable()
                .frame(width: 30, height: 30)
//                .offset(x: position.width + dragOffset.width, y: position.height + dragOffset.height)
                
//                .animation(.linear)
//                .gesture(DragGesture()
//                    .updating(self.$dragOffset, body: { (value, state, transaction) in
//                        state = value.translation
//                    })
//                    .onEnded({ (value) in
//                        self.position.height += value.translation.height
//                        self.position.width += value.translation.width
//                    })
//            )
                .position(pos)
            )
        } else {
            return AnyView(Image("outdoor pod"))
        }
    }
}

enum PodType {
    case outdoor, corner, hallway, ceiling
}

let podImageDict: [PodType : String] = [
    .outdoor : "outdoor pod",
    .corner : "corner pod",
    .hallway : "hallway pod",
    .ceiling : "ceiling pod"
]

struct PodNodeView_Previews: PreviewProvider {
    static var previews: some View {
        PodNodeView(podType: .hallway, pos: CGPoint(x: 250, y: 250), isActive: true)
    }
}
