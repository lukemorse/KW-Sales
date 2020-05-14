//
//  CreatePodMapView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/15/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct CreatePodMapView: View {
    @State var showImagePicker: Bool = false
    @State var image: Image?
    var viewModel: InstallationViewModel
    var floorPlanIndex: Int
    
    @State var pods: [Pod] = []
    
    @State var isLoading = false
    @State var showingActionSheet = false
    @State private var position = CGSize.zero
//    @State var podNodes: [PodNodeView] = []
    
    @State var scale: CGFloat = 1.0
    @State var newScaleValue: CGFloat = 1.0
    @State var lastScaleValue: CGFloat = 1.0
    
    @State var tapPoint: CGPoint = CGPoint.zero
    @State var dragSize: CGSize = CGSize.zero
    @State var lastDrag: CGSize = CGSize.zero
    
    @State var isPlacingPod: Bool = false
    @State var nextPodType: PodType = .vertical_hallway
    @State var podIndex = 0
    
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                self.image != nil ? self.image?.resizable() : Image("blankImage").resizable()
//                self.image ?? Image("blankImage")
//                    .resizable()
                self.podGroup
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
                if self.scale < 1 {self.scale = 1}
                
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
                
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(sourceType: .photoLibrary) { image in
                        self.image = Image(uiImage: image)
                            .resizable()
                        self.isLoading = true
//                        self.viewModel.floorPlanImages.insert(Image(uiImage: image), at: 0)
                        self.viewModel.floorPlanImages.append(Image(uiImage: image))
                        self.viewModel.uploadFloorPlan(image: image) { success in
                            if success {
                                self.isLoading = false
                            } else {
                                self.isLoading = false
                                print("error uploading image")
                            }
                        }
                    }
            }
            
            Spacer()
            actionSheetButton
        }
        .onAppear() {
            if self.image == nil {
                self.showImagePicker.toggle()
            }
            self.getPods()
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
                self.addPod(pod: Pod(podType: self.nextPodType, position: value.location))
            })
            ))
        } else {
            return AnyView(EmptyView())
        }
    }
    
    var podGroup: some View {
        if pods.count > 0 {
            return AnyView(
                Group {
                    ForEach(0..<pods.count, id: \.self) { index in
                        PodNodeView(podType: self.pods[index].podType, pos: self.pods[index].position)
                            .onTapGesture {
                                print("tapped")
                        }
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
                .padding()
                .foregroundColor(Color.black)
                .background(Color.blue)
                .cornerRadius(15)
                .shadow(radius: 10)
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
                    .default(Text("Horizontal Hallway POD"), action: {
                        self.nextPodType = .horizontal_hallway
                        self.isPlacingPod = true
                    }),
                    .default(Text("Vertical Hallway POD"), action: {
                        self.nextPodType = .vertical_hallway
                        self.isPlacingPod = true
                    }),
                    .cancel()])
        })
    }
    
    func getPods() {
        let key = floorPlanIndex >= viewModel.installation.floorPlanUrls.count ? "" : viewModel.installation.floorPlanUrls[floorPlanIndex]
        self.pods = viewModel.installation.pods[key] ?? []
    }
    
    func addPod(pod: Pod) {
        if isLoading {
            return
        }
        self.pods.append(pod)
        self.isPlacingPod = false
        
        //add to implementation plan
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
        CreatePodMapView(viewModel: InstallationViewModel(installation: Installation(), teams: [Team()]), floorPlanIndex: 0)
    }
}


