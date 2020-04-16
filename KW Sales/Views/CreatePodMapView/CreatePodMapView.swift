//
//  CreatePodMapView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/15/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct CreatePodMapView: View {
    @State var showingActionSheet: Bool
    @State private var position = CGSize.zero
    @State var podNodes: [PodNodeView] = []
    
    @GestureState private var dragOffset = CGSize.zero
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geo in
                    Image("floorPlan")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width)
                        .clipped()
                }
                if podNodes.count > 0 {
                    ForEach(podNodes, id: \.self) { pod in
                        pod
                    }
                } else {
                    EmptyView()
                }
                
                
                
                
            }
            Button(action: {
                self.showingActionSheet = true
            }) {
                Text("Show ActionSheet")
                    .font(.title)
                    .foregroundColor(Color.yellow)
            }
            .actionSheet(isPresented: $showingActionSheet, content: {
                            ActionSheet(title: Text("Add POD"), message: Text("Choose POD Type"), buttons:
                                [
                                 .default(Text("Outdoor POD"), action: {
                                    self.podNodes.append(PodNodeView(podType: .outdoor, isActive: true))
                                 }),
                                 .default(Text("Corner POD"), action: {
                                    self.podNodes.append(PodNodeView(podType: .corner, isActive: true))
                                 }),
                                 .default(Text("Hallway POD"), action: {
                                    self.podNodes.append(PodNodeView(podType: .hallway, isActive: true))
                                 }),
                                 .default(Text("Ceiling POD"), action: {
                                    self.podNodes.append(PodNodeView(podType: .ceiling, isActive: true))
                                 }),
                                 .cancel()])
                        }) 
        }
    }
    
    func makePodNode(_ isActive: Bool, offset: CGSize ) -> some View {
        if isActive {
            return AnyView(Image("outdoor pod")
                .offset(x: position.width + dragOffset.width, y: position.height + dragOffset.height)
                .animation(.linear)
                .gesture(DragGesture()
                    .updating(self.$dragOffset, body: { (value, state, transaction) in
                        state = value.translation
                    })
                    .onEnded({ (value) in
                        self.position.height += value.translation.height
                        self.position.width += value.translation.width
                    })
            ))
        } else {
            return AnyView(Image("outdoor pod"))
        }
    }
}



struct CreatePodMapView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePodMapView(showingActionSheet: false)
    }
}


