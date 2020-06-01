//
//  PodMapMasterView.swift
//  KW Sales
//
//  Created by Luke Morse on 5/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct PodMapMasterView: View, Equatable {
    @Environment(\.imageCache) var cache: ImageCache
    @ObservedObject var viewModel: InstallationViewModel
    @State var selection: Int?
    @State var showImagePicker: Bool = false
    @State var isLoading = false
    
    var body : some View {
        let urlArray = viewModel.installation.floorPlanUrls.chunked(into: 2)
        return ZStack {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: true) {
                    VStack {
                        ForEach(0..<urlArray.count, id: \.self) { row in // create number of rows
                            HStack {
                                ForEach(0..<urlArray[row].count, id: \.self) { column in // create 2 columns
                                    self.getNavLink(index: row * 2 + column, size: geometry.size)
                                }
                            }.padding()
                        }
                    }
                }
            }
            if isLoading {
                ActivityIndicator()
            }
        }
        .navigationBarItems(trailing: addButton)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary) { image in
                self.isLoading = true
                self.viewModel.uploadFloorPlan(image: image) { (success, urlString) in
                    if success {
                        let url = URL(string: urlString!)!
                        self.cache.setImage(image, url: url)
                        self.isLoading = false
                    } else {
                        self.isLoading = false
                        print("error uploading image")
                    }
                }
            }
        }
    }
    
    var addButton: some View {
        Button(action: {
            self.showImagePicker = true
        }) {
            Text("New")
        }
    }
    
    func getNavLink(index: Int, size: CGSize) -> some View {
        let asyncImage = AsyncImage(url: URL(string: self.viewModel.installation.floorPlanUrls[index])!, cache: self.cache, placeholder: Text("Loading...").padding(), configuration:
        {$0.resizable()})
        
        return NavigationLink(destination: CreatePodMapView(floorPlanIndex: index).environmentObject(self.viewModel), tag: index, selection: $selection) {
            asyncImage
                .aspectRatio(contentMode: .fit)
                .border(Color.black)
                .frame(width: size.width / 2.5)
                .onTapGesture {
                    self.selection = index
            }
        }
        .buttonStyle(PlainButtonStyle())
        .inExpandingRectangle()
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.viewModel.installation.floorPlanUrls.count == rhs.viewModel.installation.floorPlanUrls.count &&
            lhs.selection == rhs.selection
    }
}

struct ThumbnailNavLinkView: View, Equatable {
    let url: URL
    let cache: ImageCache
    let index: Int
    let size: CGSize
    @State var selection: Int?
    
    
    var body: some View {
        let asyncImage = AsyncImage(url: url, cache: self.cache, placeholder: Text("Loading...").padding(), configuration:
        {$0.resizable()})
        
        return NavigationLink(destination: CreatePodMapView(floorPlanIndex: index), tag: index, selection: $selection) {
            asyncImage
                .aspectRatio(contentMode: .fit)
                .border(Color.black)
                .frame(width: size.width / 2.5)
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.url == rhs.url
    }
}



//struct PodMapMasterView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = InstallationViewModel(installation: Installation())
//        viewModel.floorPlanImages.append(Image(systemName: "plus"))
//        viewModel.floorPlanImages.append(Image(systemName: "plus"))
//        return
//            NavigationView {
////                PodMapMasterView(viewModel: viewModel)
//                Image(systemName: "plus")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .scaleEffect(0.5)
//                .foregroundColor(Color.blue)
//                .border(Color.black)
//                .frame(width: 200, height: 200)
//        }
//    }
//}

extension View {
    func inExpandingRectangle() -> some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
            self
        }
    }
}
