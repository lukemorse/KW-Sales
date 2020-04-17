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
    
    @State var scale: CGFloat = 1.0
    @State var newScaleValue: CGFloat = 1.0
    @State var lastScaleValue: CGFloat = 1.0
    
    @State var tapPoint: CGPoint = CGPoint.zero
    @State var dragSize: CGSize = CGSize.zero
    @State var lastDrag: CGSize = CGSize.zero
    
    @State var isPlacingPod: Bool = false
    @State var nextPodType: PodType = .ceiling
    
    @GestureState private var dragOffset = CGSize.zero
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geo in
                    ZStack {
                        Image("floorPlan")
                            .resizable()
                        
                        
                        
                        self.podGroup
                            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ val in
                                print("dragging pod")
                                self.tapPoint = val.startLocation
                                self.dragSize = CGSize(width: val.translation.width + self.lastDrag.width, height: val.translation.height + self.lastDrag.height)
                            })
                                .onEnded({ (val) in
                                    self.dragSize = CGSize(width: val.translation.width + self.lastDrag.width, height: val.translation.height + self.lastDrag.height)
                                    self.lastDrag = self.dragSize
                                }))
                    }
                    .scaledToFit()
                    .animation(.linear)
                    .scaleEffect(self.scale)
                    .offset(self.dragSize)
                    .gesture(MagnificationGesture().onChanged { val in
                        let delta = val / self.lastScaleValue
                        self.lastScaleValue = val
                        self.scale = self.scale * delta
                        
                    }.onEnded { val in
                        // without this the next gesture will be broken
                        self.lastScaleValue = 1.0
                        }
                        
                    )
                        .simultaneousGesture(DragGesture(minimumDistance: 1, coordinateSpace: .local).onChanged({ val in
                            print("dragging map")
                            self.tapPoint = val.startLocation
                            self.dragSize = CGSize(width: val.translation.width + self.lastDrag.width, height: val.translation.height + self.lastDrag.height)
                            
                            
                        })
                            .onEnded({ (val) in
                                self.dragSize = CGSize(width: val.translation.width + self.lastDrag.width, height: val.translation.height + self.lastDrag.height)
                                self.lastDrag = self.dragSize
                            }))
                        .simultaneousGesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ (val) in
                            if self.isPlacingPod {
                                
                                let startingPoint = val.startLocation
                                print("1")
                                print(startingPoint)
                                self.podNodes.append(PodNodeView(podType: self.nextPodType, pos: startingPoint, isActive: true))
                                self.isPlacingPod = false
                            }
                        }))
                    
                }
            }
            actionSheetButton
        }
    }
    
    var podGroup: some View {
        if podNodes.count > 0 {
            return AnyView(
                Group {
                    ForEach(podNodes, id: \.self) { pod in
                        pod
                    }
                }
            )
        }
        else {
            return AnyView(EmptyView())
        }
    }
    
    var actionSheetButton: some View {
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
                        self.nextPodType = .outdoor
                        self.isPlacingPod = true
                    }),
                    .default(Text("Corner POD"), action: {
                        self.nextPodType = .corner
                        self.isPlacingPod = true
                    }),
                    .default(Text("Hallway POD"), action: {
                        self.nextPodType = .hallway
                        self.isPlacingPod = true
                    }),
                    .default(Text("Ceiling POD"), action: {
                        self.nextPodType = .ceiling
                        self.isPlacingPod = true
                    }),
                    .cancel()])
            
            
        })
        
    }
}



struct CreatePodMapView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePodMapView(showingActionSheet: false)
    }
}


