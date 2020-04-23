//
//  PendingView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct PendingListView: View {
    @ObservedObject var viewModel = PendingListViewModel()
    var body: some View {
        listView
            .onAppear() {
                self.viewModel.getDistricts()
        }
    }
    
    var listView : some View {
        if self.viewModel.districts.count > 0 {
            return AnyView(List {
                ForEach(0..<self.viewModel.districts.count, id: \.self) {index in
                    VStack {
                        NavigationLink(self.viewModel.districts[index].districtName ?? "", destination:
                            PendingDetailView(district: self.viewModel.districts[index])
                        )
                    }
                }
            })
        }
        return AnyView(List {
            Text("No Schools found")
        })
        
    }
}

struct PendingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PendingListView()
        }
        
    }
}
