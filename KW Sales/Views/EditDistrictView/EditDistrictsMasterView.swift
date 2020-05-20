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
    @State private var addedDistrict: Binding<District>?
    @State private var addedDistrictIndex = 0
    @State private var shouldNavigate = false
    @State private var showFilterMenu = false
    
    var body: some View {
        listView
            //        testButton
            .onAppear() {
                if(self.viewModel.districts.isEmpty) {
                    self.viewModel.fetchDistricts()
                    self.viewModel.fetchTeams()
                }
        }
        .navigationBarItems(leading: Image("Logo"), trailing: filterButton)
        .actionOver(presented: $showFilterMenu, title: "Filter Districts", message: nil, buttons: actionButtons, ipadAndMacConfiguration: ipadMacConfig)
    }
    
    var filterButton: some View {
        Button(action: {
            self.showFilterMenu = true
        }) {
            Text("Filter")
                .foregroundColor(Color.blue)
        }.actionSheet(isPresented: $showFilterMenu, content: {
            ActionSheet(title: Text("Filter Districts"), message: Text("Add or remove filter"), buttons:
                [
                    .default(Text("Pending Districts"), action: {
                        self.viewModel.changeFilter(filterIndex: 1)
                    }),
                    .default(Text("Complete Districts"), action: {
                        self.viewModel.changeFilter(filterIndex: 2)
                    }),
                    .default(Text("Added By Me"), action: {
                        self.viewModel.changeFilter(filterIndex: 3)
                    }),
                    .default(Text("Remove Filter"), action: {
                        self.viewModel.changeFilter(filterIndex: 0)
                    }),
                    .cancel()])
        }
        )
    }
    
    var listView: some View {
        AnyView(List {
            addDistrictButton
            if self.viewModel.filteredDistricts.count > 0 {
                ForEach(0..<viewModel.districts.count, id: \.self) { index in
                    NavigationLink(self.viewModel.districts[index].districtName, destination: AddDistrictView(districtIndex: index, newFlag: false))
                        .font(.title)
                }
            }
            //            navLink
        })
    }
    
    var actionButtons: [ActionOverButton] {
        [
        ActionOverButton(title: "Pending", type: .normal) {
            self.viewModel.changeFilter(filterIndex: 1)
        },
        ActionOverButton(title: "Complete", type: .normal) {
            self.viewModel.changeFilter(filterIndex: 2)
        },
        ActionOverButton(title: "Added By Me", type: .normal) {
            self.viewModel.changeFilter(filterIndex: 3)
        },
        ActionOverButton(title: "Remove Filter", type: .normal) {
            self.viewModel.changeFilter(filterIndex: 0)
        },
        ActionOverButton(title: "Cancel", type: .cancel) {
            self.showFilterMenu = false
            }
        ]
    }
    
    private var ipadMacConfig = {
        return IpadAndMacConfiguration(anchor: UnitPoint.topTrailing, arrowEdge: .trailing)
    }()
    
//    func getConfig() -> IpadAndMacConfiguration {
//        var anchor = UnitPoint.topTrailing
//        anchor.x -= 100
//        return IpadAndMacConfiguration(anchor: anchor, arrowEdge: .trailing)
//    }
    
    var addDistrictButton: some View {
        return Button(action: {
            self.addedDistrictIndex = self.viewModel.districts.count
            self.addedDistrict = self.viewModel.addDistrict()
            self.shouldNavigate = true
        }) {
            NavigationLink(destination: AddDistrictView( districtIndex: self.addedDistrictIndex, newFlag: true), isActive: self.$shouldNavigate) {
                Text("Add District")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .multilineTextAlignment(.center)
                    .cornerRadius(5)
                    .shadow(radius: 5)
            }.buttonStyle(PlainButtonStyle())
            
        }
    }
    
    var testButton: some View {
        Button(action: {
            self.viewModel.addDistrict()
            self.viewModel.districts[0] = TestDB.district1
            self.viewModel.uploadDistrict(districtIndex: 0) { (success) in
                print(success)
            }
        }) {
            Text("TEST")
        }
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
