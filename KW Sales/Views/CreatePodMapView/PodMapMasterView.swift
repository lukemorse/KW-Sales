//
//  PodMapMasterView.swift
//  KW Sales
//
//  Created by Luke Morse on 5/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

class PodMapMasterViewModel: ObservableObject {
    @Published var floorPlanImages: [Image] = [Image(systemName: "plus")]
}

struct PodMapMasterView: View {
    @ObservedObject var viewModel: PodMapMasterViewModel
    @State var selectedImageIndex = 0
    @State var selection: Int?
    
    var body : some View {
        VStack {
            GeometryReader { geometry in
                List {
                    if self.viewModel.floorPlanImages.count > 0 {
                        ForEach(0..<self.viewModel.floorPlanImages.chunked(into: 3).count) { row in // create number of rows
                            HStack {
                                ForEach(0..<self.viewModel.floorPlanImages.chunked(into: 3)[row].count, id: \.self) { column in // create 3 columns
                                    
                                    self.viewModel.floorPlanImages[column]
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width / 2.5)
                                        .border(Color.black)
                                        .onTapGesture {
                                            print("tapped")
                                            self.selectedImageIndex = row * 3 + column
                                            self.selection = row * 3 + column
                                    }
                                }
                            }
                        }
                    }
                    else {
                        EmptyView()
                    }
                }
            }
            .frame(height: 300)
            .padding()
            getNavLink()
        }
        .onAppear() {
            self.selection = nil
            //            self.viewModel.getFloorPlans()
        }
    }
    
    func getNavLink() -> some View {
        return NavigationLink(destination:
            selectedImageIndex == 0
                ? AnyView(viewModel.floorPlanImages[selectedImageIndex])
                : AnyView(Text("HI")), tag: selectedImageIndex, selection: self.$selection) {
                    Text("").hidden()}
    }
    
}

struct PodMapMasterView_Previews: PreviewProvider {
    static var previews: some View {
        PodMapMasterView(viewModel: PodMapMasterViewModel())
    }
}
