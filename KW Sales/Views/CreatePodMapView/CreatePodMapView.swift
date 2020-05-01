//
//  CreatePodMapView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/15/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import Firebase

struct CreatePodMapView: View {
    @State var showImagePicker: Bool = false
    @State var image: Image? = nil
    var viewModel: InstallationViewModel
    var floorPlanIndex: Int
    
    @State var isLoading = false
    @State var showingActionSheet = false
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
    @State var podIndex = 0
    
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                self.image ?? Image("blankImage")
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
                if isLoading {
                    ActivityIndicator()
                }
                
            }
            .coordinateSpace(name: "custom")
            .overlay(podPlacementGesture)
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
                    
                    self.tapPoint = val.startLocation
                    self.dragSize = CGSize(width: val.translation.width + self.lastDrag.width, height: val.translation.height + self.lastDrag.height)
                })
                    .onEnded({ (val) in
                        self.dragSize = CGSize(width: val.translation.width + self.lastDrag.width, height: val.translation.height + self.lastDrag.height)
                        self.lastDrag = self.dragSize
                    }))
//                .simultaneousGesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ (val) in
//
//
//                    // TODO: Fix starting point when scaled
//
//                    if self.isPlacingPod {
//                        let tapPoint = CGPoint(x: val.startLocation.x - self.dragSize.width, y: val.startLocation.y - self.dragSize.height)
//                        self.addPod(type: self.nextPodType, location: tapPoint)
//                    }
//                }))
                
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(sourceType: .photoLibrary) { image in
                        self.image = Image(uiImage: image)
                            .resizable()
                        self.isLoading = true
                        self.viewModel.uploadFloorPlan(image: image) { success in
                            if success {
                                self.isLoading = false
                            } else {
                                self.isLoading = false
                                // error uploading image
                            }
                        }
                    }
            }
            
            Spacer()
            actionSheetButton
            
        }
        .onAppear() {
            self.showImagePicker.toggle()
            
        }
    }
    
    var podPlacementGesture: some View {
        
        if self.isPlacingPod {
            return AnyView(GeometryReader {geo in
                Color.clear.contentShape(Rectangle())
            }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .named(AnyHashable("custom")))
            .onChanged({ (value) in
                print(value.location)
                self.addPod(type: self.nextPodType, location: value.location)
            })
            ))
        } else {
            return AnyView(EmptyView())
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
            Text("Add KW POD")
                .font(.title)
                .foregroundColor(Color.blue)
                .background(Color.white)
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
    
    func addPod(type: PodType, location: CGPoint) {
        if isLoading {
            return
        }
        let podView = PodNodeView(podType: type, pos: location)
        self.podNodes.append(podView)
        self.isPlacingPod = false
        
        //add to implementation plan
        let pod = Pod(podType: type, position: location)
        let key = self.viewModel.installation.floorPlanUrls[floorPlanIndex]
        if self.viewModel.installation.pods.keys.contains(key) {
            self.viewModel.installation.pods[key]?.append(pod)
        } else {
            self.viewModel.installation.pods[key] = [pod]
        }
    }
}

struct CreatePodMapView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePodMapView(viewModel: InstallationViewModel(installation: Installation()), floorPlanIndex: 0)
    }
}


