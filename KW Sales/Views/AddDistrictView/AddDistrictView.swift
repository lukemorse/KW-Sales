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
    
    @State var districtName: String = ""
    @State var numPreKSchools: Int = 0
    @State var numElementaryKSchools: Int = 0
    @State var numMiddleSchools: Int = 0
    @State var numHighSchools: Int = 0
    @State var districtContactName: String = ""
    @State var districtContactEmail: String = ""
    @State var districtContactPhone: String = ""
    @State var districtOfficeAddress: String = ""
    @State var assignedTeam: Team = Team()
    @State var numPods: Int = 0
    @State var startDate: Date = Date()
    @State var readyToInstall: Bool = false
    
    @State private var isShowingAddDistrictAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Group {
                    Button(action: {
                        self.importCSV()
                    }) {
                        Text("Import CSV")
                    }
                }
                
                
                Section(header: Text("General")) {
                    Group {
                        formItem(with: $numPods, label: "Number of Pods Needed")
                        formItem(with: $startDate, label: "Start Date")
                    }
                }
                
                Section(header: Text("District Information")){
                    Group {
                        formItem(with: $districtName, label: "District Name")
                        formItem(with: $numPreKSchools, label: "Number of Pre-K Schools")
                        formItem(with: $numElementaryKSchools, label: "Number of Elementary Schools")
                        formItem(with: $numMiddleSchools, label: "Number of Middle Schools")
                        formItem(with: $numHighSchools, label: "Number of High Schools")
                    }
                }
                
                Section(header: Text("Contact Information")) {
                    Group {
                        formItem(with: $districtContactName, label: "District Contact Person")
                        formItem(with: $districtContactEmail, label: "District Contact Email")
                        formItem(with: $districtContactPhone, label: "District Contact Phone Number")
                        formItem(with: $districtOfficeAddress, label: "District Office Address")
                        //                        teamPicker(with: $assignedTeam, label: "Assign Team")
                        if viewModel.teams.count > 0 {
                            
                            Picker(selection: $assignedTeam, label: Text("Select Team"), content: {

                                ForEach(viewModel.teams, id: \.id) { team in
                                    Text(team.name).tag(team)
                                }
                            })
                            
                        } else {
                            Text("no teams")
                        }
                        
                        Toggle(isOn: $readyToInstall) {
                            Text("Ready To Install")
                        }
                    }
                }
                NavigationLink(destination: CreateImplementationPlanListView()) {
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
        SendPodOrderButtonView(numPods: numPods, email: districtContactEmail, textColor: validateEmail(enteredEmail: districtContactEmail) ? Color.green : Color.red)
    }
    
    var addDistrictButton: some View {
        Button(action: {
            self.addDistrict()
        }) {
            Text("Add District")
                .foregroundColor(self.formIsEmpty() ? Color.red : Color.green)
        }
    }
    
    func importCSV() {
        let arr = parseCSV()
        self.numPods = Int(arr[0]) ?? 0
        
        let dateString = arr[1]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        self.startDate = dateFormatter.date(from: dateString) ?? Date()
        
        self.districtName = arr[2]
        self.numPreKSchools = Int(arr[3]) ?? 0
        self.numElementaryKSchools = Int(arr[4]) ?? 0
        self.numMiddleSchools = Int(arr[5]) ?? 0
        self.numHighSchools = Int(arr[6]) ?? 0
        self.districtContactName = arr[7]
        self.districtContactPhone = arr[8]
        self.districtOfficeAddress = arr[9]
    }
    
    //Funcs for adding form items
    
    func formItem(with name: Binding<String>, label: String) -> some
        View {
            return VStack(alignment: .leading) {
                Text(label)
                    .font(.headline)
                TextField("Enter " + label, text: name)
                    .padding(.all)
                
            }
            .padding(.horizontal, 15)
    }
    
    func formItem(with name: Binding<Int>, label: String) -> some
        View {
            return VStack(alignment: .leading) {
                Text(label)
                    .font(.headline)
                
                Picker(selection: name, label: Text(""), content: {
                    ForEach(0..<50, id: \.self) { idx in
                        Text(String(idx))
                    }
                })
                    .padding(.all)
            }
            .padding(.horizontal, 15)
    }
    
    func formItem(with name: Binding<Date>, label: String) -> some View {
        return VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
            DatePicker(selection: name, displayedComponents: .date) {
                Text("")
            }
        }
        .padding(.horizontal, 15)
    }
    
    func teamPicker(with name: Binding<Team?>, label: String) -> some View {
        let teams = self.viewModel.teamDict.map {$0.value}
        return VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
            
            Picker(selection: name, label: Text(""), content: {
                ForEach(0..<teams.count, id: \.self) { index in
                    Text(teams[index].name).tag(index)
                }
            }).id(teams)
                
                .pickerStyle(DefaultPickerStyle())
                .padding(.all)
        }
        .padding(.horizontal, 15)
    }
    
    func addDistrict() {
        if formIsEmpty() {
            isShowingAddDistrictAlert = true
            return
        }
        if let team = viewModel.teamDict.first(where: { $0.value == assignedTeam })?.key {
            let district = District(readyToInstall: readyToInstall, numPreKSchools: numPreKSchools, numElementarySchools: numElementaryKSchools, numMiddleSchools: numMiddleSchools, numHighSchools: numHighSchools, districtContactPerson: districtContactName, districtEmail: districtContactEmail, districtPhoneNumber: districtContactPhone, districtOfficeAddress: districtOfficeAddress, team: team, numPodsNeeded: numPods, startDate: startDate)
            
            viewModel.addDistrict(district: district)
            
        } else {
            print("could not find team")
        }
    }
    
    func formIsEmpty() -> Bool {
        return districtContactName.isEmpty ||
        districtContactEmail.isEmpty ||
        districtContactPhone.isEmpty ||
        districtOfficeAddress.isEmpty
    }
}

struct AddDistrictView_Previews: PreviewProvider {
    static var previews: some View {
        AddDistrictView()
        //            .environment(\.colorScheme, .dark)
    }
}
