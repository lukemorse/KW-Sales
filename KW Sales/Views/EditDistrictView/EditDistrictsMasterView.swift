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
        listView
            .onAppear() {
                if(self.viewModel.filteredDistrictNames.isEmpty) {
                    self.viewModel.fetchDistrictList()
                    self.viewModel.fetchTeams()
                }
        }
        .navigationBarItems(leading: Image("Logo"), trailing: filterButton)
        .actionOver(presented: $showFilterMenu, title: "Filter Districts", message: nil, buttons: actionButtons, ipadAndMacConfiguration: getIpadMacConfig())
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
                        self.viewModel.changeFilter(districtFilter: .pending)
                    }),
                    .default(Text("Complete Districts"), action: {
                        self.viewModel.changeFilter(districtFilter: .complete)
                    }),
                    .default(Text("Added By Me"), action: {
                        self.viewModel.changeFilter(districtFilter: .currentUser)
                    }),
                    .default(Text("Remove Filter"), action: {
                        self.viewModel.changeFilter(districtFilter: .noFilter)
                    }),
                    .cancel()])
        }
        )
    }
    
    var listView: some View {
        AnyView(List {
            addDistrictButton
            if viewModel.filteredDistrictNames.count > 0 {
                ForEach(0..<viewModel.filteredDistrictNames.count, id: \.self) { index in
                    NavigationLink(self.viewModel.filteredDistrictNames[index], destination: EditDistrictDetailView(docPath: self.viewModel.filteredDistricts[index].districtID, newFlag: false, uploadDistrictHandler: self.viewModel.uploadDistrict
                    ))
                        .font(.title)
                        .padding()
                }
            }
        })
    }
    
    var addDistrictButton: some View {
        return Button(action: {
            self.addedDistrict = District()
            self.shouldNavigate = true
        }) {
            NavigationLink(destination:
                EditDistrictDetailView(docPath: self.addedDistrict?.districtID ?? "", newFlag: true), isActive: self.$shouldNavigate) {
                Text("Add District")
                    .font(.title)
                    .padding()
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
}

//ActionOver
extension EditDistrictsMasterView {
    var actionButtons: [ActionOverButton] {
        [
            ActionOverButton(title: "Pending", type: .normal) {
                self.viewModel.changeFilter(districtFilter: .pending)
            },
            ActionOverButton(title: "Complete", type: .normal) {
                self.viewModel.changeFilter(districtFilter: .complete)
            },
            ActionOverButton(title: "Added By Me", type: .normal) {
                self.viewModel.changeFilter(districtFilter: .currentUser)
            },
            ActionOverButton(title: "Remove Filter", type: .normal) {
                self.viewModel.changeFilter(districtFilter: .noFilter)
            },
            ActionOverButton(title: "Cancel", type: .cancel) {
                self.showFilterMenu = false
            }
        ]
    }
    
    private func getIpadMacConfig() -> IpadAndMacConfiguration {
        return IpadAndMacConfiguration(anchor: UnitPoint.topTrailing, arrowEdge: .trailing)
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
