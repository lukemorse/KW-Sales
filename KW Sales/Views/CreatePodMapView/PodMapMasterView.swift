//
//  PodMapMasterView.swift
//  KW Sales
//
//  Created by Luke Morse on 5/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct PodMapMasterView: View {
    @ObservedObject var viewModel: InstallationViewModel
    @State var selectedImageIndex = 0
    @State var selection: Int?
    
    var body : some View {
        let array = self.getImageArrayWithPlusSign().chunked(into: 2)
        return GeometryReader { geometry in
            List {
                ForEach(0..<array.count, id: \.self) { row in // create number of rows
                    HStack {
                        ForEach(0..<array[row].count, id: \.self) { column in // create 2 columns
                            
                            array[row][column]
                                .resizable()
                                .scaledToFill()
                                .border(Color.black)
                                .frame(width: geometry.size.width / 2.5)
                                .onTapGesture {
                                    print("tapped")
                                    self.selectedImageIndex = row * 2 + column
                                    self.selection = row * 2 + column
                            }
                        }
                    }
                }
                self.getNavLink()
            }
        }
        .onAppear() {
            self.selection = nil
        }
    }
    
    func getImageArrayWithPlusSign() -> [Image] {
        return viewModel.floorPlanImages + [Image(systemName: "plus")]
    }
    
    func getNavLink() -> some View {
        return NavigationLink(destination:
        CreatePodMapView(image: selectedImageIndex >= self.viewModel.floorPlanImages.count ? nil : self.viewModel.floorPlanImages[selectedImageIndex], viewModel: self.viewModel, floorPlanIndex: self.selectedImageIndex), tag: selectedImageIndex, selection: self.$selection) {
            Text("")
        }.hidden()
        
        //        return NavigationLink(destination:
        //            selectedImageIndex == 0
        ////                ? AnyView(viewModel.floorPlanImages[selectedImageIndex])
        //            ? AnyView(CreatePodMapView(viewModel: self.viewModel, floorPlanIndex: self.selectedImageIndex))
        //                : AnyView(Text("HI")), tag: selectedImageIndex, selection: self.$selection) {
        //                    Text("").hidden()}
    }
    
}

struct PodMapMasterView_Previews: PreviewProvider {
    static var previews: some View {
        PodMapMasterView(viewModel: InstallationViewModel(installation: Installation(), teams: []))
    }
}
