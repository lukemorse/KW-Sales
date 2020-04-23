//
//  AddDistrictView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct AddDistrictView: View {
    @ObservedObject var viewModel = AddDistrictViewModel()
    @ObservedObject var implementationPlanViewModel = ImplementationPlanListViewModel()
    
    @State private var isShowingAddDistrictAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Group {
                    Button(action: {
                        self.viewModel.importCSV()
                    }) {
                        Text("Import CSV")
                    }
                }
                
                Section(header: Text("General")) {
                    Group {
                        //                        formItem(with: $numPods, label: "Number of Pods Needed")
                        numPodPicker
                        startDatePicker
                    }
                }
                
                Section(header: Text("District Information")){
                    Group {
                        districtNameField
                        numPreKSchoolsPicker
                        numElementarySchoolsPicker
                        numMiddleSchoolsPicker
                        numHighSchoolsPicker
                    }
                }
                
                Section(header: Text("Contact Information")) {
                    Group {
                        districtContactPersonField
                        districtEmailField
                        districtPhoneField
                        districtAddressField
                        teamPicker()
                        readyToInstallToggle
                    }
                }
                NavigationLink(destination: CreateImplementationPlanListView(viewModel: self.implementationPlanViewModel)) {
                    Text("Create Implementation Plan")
                        .foregroundColor(Color.blue)
                    
                }
                sendPodButton
                addDistrictButton
            }
                
            .navigationBarTitle("Add District")
        }
        .alert(isPresented: self.$isShowingAddDistrictAlert) {
            Alert(title: Text("Please complete all fields"))
        }
        
    }
    
    var sendPodButton: some View {
        //Button is red until email is valid
        SendPodOrderButtonView(numPods: viewModel.district?.numPodsNeeded ?? 0, email: viewModel.district?.districtEmail ?? "", textColor: validateEmail(enteredEmail: viewModel.district?.districtEmail ?? "") ? Color.green : Color.red)
    }
    
    var addDistrictButton: some View {
        Button(action: {
            self.viewModel.uploadDistrict()
        }) {
            Text("Add District")
                .foregroundColor(self.formIsEmpty() ? Color.red : Color.green)
        }
    }
    
    //Funcs for adding form items
    
    var numPodPicker: some View {
        VStack(alignment: .leading) {
            Text("Number PODS Needed")
                .font(.headline)
            
            Picker(selection:
                Binding<Int>(
                    get: {self.viewModel.district?.numPodsNeeded ?? 0},
                    set: {self.viewModel.district?.numPodsNeeded = $0}),
                   
                   label: Text(""), content: {
                    ForEach(0..<50, id: \.self) { idx in
                        Text(String(idx))
                    }
            })}
    }
    
    var startDatePicker: some View {
        VStack(alignment: .leading) {
            Text("Start Date")
                .font(.headline)
            
            DatePicker(selection: Binding<Date>(
                get: {self.viewModel.district?.startDate ?? Date()},
                set: {self.viewModel.district?.startDate = $0}), displayedComponents: .date) {
                    Text("")
            }
        }
    }
    
    var districtNameField: some View {
        VStack(alignment: .leading) {
            Text("District Name")
                .font(.headline)
            TextField("Enter District Name", text: Binding<String>(
            get: {self.viewModel.district?.districtName ?? ""},
            set: {self.viewModel.district?.districtName = $0}
            ))
                .padding(.all)
        }
        .padding(.horizontal, 15)
    }
    
    var numPreKSchoolsPicker: some View {
        VStack(alignment: .leading) {
            Text("Number of Pre-K Schools")
                .font(.headline)
            
            Picker(selection:
                Binding<Int>(
                    get: {self.viewModel.district?.numPreKSchools ?? 0},
                    set: {self.viewModel.district?.numPreKSchools = $0}),
                   
                   label: Text(""), content: {
                    ForEach(0..<50, id: \.self) { idx in
                        Text(String(idx))
                    }
            })}
    }
    
    var numElementarySchoolsPicker: some View {
        VStack(alignment: .leading) {
            Text("Number of Elementary Schools")
                .font(.headline)
            
            Picker(selection:
                Binding<Int>(
                    get: {self.viewModel.district?.numElementarySchools ?? 0},
                    set: {self.viewModel.district?.numElementarySchools = $0}),
                   
                   label: Text(""), content: {
                    ForEach(0..<50, id: \.self) { idx in
                        Text(String(idx))
                    }
            })}
    }
    
    var numMiddleSchoolsPicker: some View {
        VStack(alignment: .leading) {
            Text("Number of Middle Schools")
                .font(.headline)
            
            Picker(selection:
                Binding<Int>(
                    get: {self.viewModel.district?.numMiddleSchools ?? 0},
                    set: {self.viewModel.district?.numMiddleSchools = $0}),
                   
                   label: Text(""), content: {
                    ForEach(0..<50, id: \.self) { idx in
                        Text(String(idx))
                    }
            })}
    }
    
    var numHighSchoolsPicker: some View {
        VStack(alignment: .leading) {
            Text("Number of High Schools")
                .font(.headline)
            
            Picker(selection:
                Binding<Int>(
                    get: {self.viewModel.district?.numHighSchools ?? 0},
                    set: {self.viewModel.district?.numHighSchools = $0}),
                   
                   label: Text(""), content: {
                    ForEach(0..<50, id: \.self) { idx in
                        Text(String(idx))
                    }
            })}
    }
    
    var districtContactPersonField: some View {
        VStack(alignment: .leading) {
            Text("District Contact Person")
                .font(.headline)
            TextField("Enter District Contact Name", text: Binding<String>(
            get: {self.viewModel.district?.districtContactPerson ?? ""},
            set: {self.viewModel.district?.districtContactPerson = $0}
            ))
                .padding(.all)
        }
        .padding(.horizontal, 15)
    }
    
    var districtEmailField: some View {
        VStack(alignment: .leading) {
            Text("District Email")
                .font(.headline)
            TextField("Enter District Email", text: Binding<String>(
            get: {self.viewModel.district?.districtEmail ?? ""},
            set: {self.viewModel.district?.districtEmail = $0}
            ))
                .padding(.all)
        }
        .padding(.horizontal, 15)
    }
    
    var districtPhoneField: some View {
        VStack(alignment: .leading) {
            Text("District Phone Number")
                .font(.headline)
            TextField("Enter District Phone Number", text: Binding<String>(
            get: {self.viewModel.district?.districtPhoneNumber ?? ""},
            set: {self.viewModel.district?.districtPhoneNumber = $0}
            ))
                .padding(.all)
        }
        .padding(.horizontal, 15)
    }
    
    var districtAddressField: some View {
        VStack(alignment: .leading) {
            Text("District Office Address")
                .font(.headline)
            TextField("Enter District Office Address", text: Binding<String>(
            get: {self.viewModel.district?.districtOfficeAddress ?? ""},
            set: {self.viewModel.district?.districtOfficeAddress = $0}
            ))
                .padding(.all)
        }
        .padding(.horizontal, 15)
    }
    
    func teamPicker() -> some View {
        let teams = self.viewModel.teamDict.map {$0.value}
        return VStack(alignment: .leading) {
            Text("Assign Team")
                .font(.headline)
            
            Picker(selection:
                Binding<Team>(
                    get: {
                        if self.viewModel.teams.count > 0 {
                            return self.viewModel.teams[self.viewModel.teamIndex]
                            
                        } else {
                            return Team()
                        }
                },
                    set: {self.viewModel.district?.team = $0}),
                   
                   label: Text(""), content: {
                    ForEach(0..<teams.count, id: \.self) { idx in
                        Text(teams[idx].name).tag(idx)
                    }
            })}
    }
    
    var readyToInstallToggle: some View {
        Toggle(isOn: Binding<Bool>(
            get: {(self.viewModel.district?.readyToInstall ?? false)},
            set: {self.viewModel.district?.readyToInstall = $0}
            ))  {
            Text("Ready To Install")
        }
    }
    
    func formIsEmpty() -> Bool {
        if let district = viewModel.district {
            return district.districtContactPerson?.isEmpty ?? true ||
                district.districtEmail?.isEmpty ?? true ||
                district.districtPhoneNumber?.isEmpty ?? true ||
                district.districtOfficeAddress?.isEmpty ?? true
        } else {
            return true
        }
    }
}

struct AddDistrictView_Previews: PreviewProvider {
    static var previews: some View {
        AddDistrictView()
        //            .environment(\.colorScheme, .dark)
    }
}
