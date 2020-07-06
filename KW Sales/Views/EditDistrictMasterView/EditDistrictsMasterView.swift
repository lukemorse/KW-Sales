//
//  EditDistrictTest.swift
//  KW Sales
//
//  Created by Luke Morse on 5/14/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import CodableFirebase
import ActionOver

struct EditDistrictsMasterView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var addedDistrict: District?
    @State private var shouldNavigate = false
    @State private var showFilterMenu = false
    
    var body: some View {
        VStack {
            searchBar
            addDistrictButton
            listView
                .onAppear() {
                    if(self.viewModel.districtList.isEmpty) {
                        self.viewModel.fetchDistricts()
                    }
                    if self.viewModel.teams.isEmpty {
                        self.viewModel.fetchTeams()
                    }
            }
            .navigationBarItems(leading: Image("Logo"), trailing: filterButton)
        }
    }
    
    private var ipadMacConfig = {
        IpadAndMacConfiguration(anchor: nil, arrowEdge: nil)
    }()
    
    var searchBar: some View {
        SearchBar(text: $viewModel.searchText, didSelect: .constant(false))
            .padding()
    }
    
    var filterButton: some View {
        Button(action: {
            self.showFilterMenu = true
        }) {
            Image(systemName: "line.horizontal.3.decrease").font(.system(size: 36))
        }
        .actionOver(
                presented: $showFilterMenu,
                title: "Filter Districts",
                message: nil,
                buttons: actionButtons,
                ipadAndMacConfiguration: ipadMacConfig
        )
        
    }
    
    var listView: some View {
        AnyView(List {
            if viewModel.districtList.count > 0 {
                ForEach(0..<viewModel.districtList.count, id: \.self) { index in
                    self.getListNavLink(index: index)
                        .font(.title)
                        .padding()
                }
            }
        })
    }
    
    func getListNavLink(index: Int) -> some View {
        let district = viewModel.districtList[index]
        let model = EditDistrictDetailViewModel(district: district)
        let view = EditDistrictDetailView(viewModel: model, newFlag: false)
        return AnyView(NavigationLink(destination: view ) {
            Text(district.districtName)
        })
    }
    
    var addDistrictButton: some View {
        return Button(action: {
            self.shouldNavigate = true
        }) {
            NavigationLink(destination:
            EditDistrictDetailView(viewModel: EditDistrictDetailViewModel(district: District()), newFlag: true), isActive: self.$shouldNavigate) {
                Text("Add District")
                    .font(.title)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .multilineTextAlignment(.center)
                    .cornerRadius(5)
                    .shadow(radius: 5)
            }.buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal)
    }
}

//ActionOver
extension EditDistrictsMasterView {
    var actionButtons: [ActionOverButton] {
        [
            ActionOverButton(
                title: "Pending Districts",
                type: .normal,
                action: {
                    self.viewModel.changeFilter(districtFilter: .pending)}
            ),
            ActionOverButton(
                title: "Complete Districts",
                type: .normal,
                action: {
                    self.viewModel.changeFilter(districtFilter: .complete)}
            ),
            ActionOverButton(
                title: "Added By Me",
                type: .normal,
                action: {
                    self.viewModel.changeFilter(districtFilter: .currentUser)}
            ),
            ActionOverButton(
                title: nil,
                type: .cancel,
                action: nil
            ),
        ]
    }
}

struct EditDistrictTest_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditDistrictsMasterView().environmentObject(MainViewModel())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
