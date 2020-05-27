//
//  PodMapMasterView.swift
//  KW Sales
//
//  Created by Luke Morse on 5/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct PodMapMasterView: View {
    @Environment(\.imageCache) var cache: ImageCache
    @ObservedObject var viewModel: InstallationViewModel
    @State var selection: Int?
    @State var showSaveAlert = false
    
    var body : some View {
        let urlArray = viewModel.installation.floorPlanUrls.chunked(into: 2)
        return GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    ForEach(0..<urlArray.count, id: \.self) { row in // create number of rows
                        HStack {
                            ForEach(0..<urlArray[row].count, id: \.self) { column in // create 2 columns
                                self.getNavLink(index: row * 2 + column, size: geometry.size, isNew: false)
                            }
                        }.padding()
                    }
                }
            }
        }
        .onAppear() {
            self.selection = nil
//            self.viewModel.downloadFloorplans()
        }
        .navigationBarItems(trailing: addButton)
//        .alert(isPresented: self.$showSaveAlert) {
//            Alert(title: Text("Saved POD Maps"))
//        }
    }
    
//    var saveButton: some View {
//        Button(action: {
//            self.showSaveAlert = true
//        }) {
//            Text("Save")
//            .foregroundColor(.blue)
//        }
//    }
    
    var addButton: some View {
        NavigationLink(destination: CreatePodMapView(viewModel: self.viewModel, floorPlanIndex: self.viewModel.floorPlanImages.count, shouldOpenImagePicker: true, image: Image("blankImage") )) {
            Image(systemName: "plus")
        }
    }
    
//    func getImageArrayWithPlusSign() -> [Image] {
//        return viewModel.floorPlanImages + [Image(systemName: "plus")]
//    }
    
    func getNavLink(index: Int, size: CGSize, isNew: Bool) -> some View {
        let asyncImage = AsyncImage(url: URL(string: self.viewModel.installation.floorPlanUrls[index])!, cache: self.cache, placeholder: Text("Loading..."), configuration:
        {$0.resizable()})
        
        var image: Image = asyncImage.getImage() ?? Image("blankImage")
        
        return NavigationLink(destination: CreatePodMapView(viewModel: self.viewModel, floorPlanIndex: index, shouldOpenImagePicker: isNew, image: image), tag: index, selection: $selection) {
            asyncImage
                .aspectRatio(contentMode: .fit)
                .border(Color.black)
                .frame(width: size.width / 2.5)
                .onTapGesture {
                    image = asyncImage.getImage() ?? Image("blankImage")
                    print(image)
                    self.selection = index
            }
        }
        .buttonStyle(PlainButtonStyle())
        .inExpandingRectangle()
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
