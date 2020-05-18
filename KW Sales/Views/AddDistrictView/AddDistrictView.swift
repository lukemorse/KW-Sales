//
//  AddDistrictView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import Combine

struct AddDistrictView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @ObservedObject private var keyboard = KeyboardResponder()
//    @ObservedObject var viewModel = AddDistrictViewModel()
    @ObservedObject var locationSearchService = LocationSearchService()
    @State private var numPodsString = ""
    @State private var isShowingAlert = false
    @State private var isFieldsIncomplete = false
    @State private var addDistrictSuccess = false
    @State private var addDistrictFail = false
    @Binding var district: District
    
//    init(with district: District) {
//        self.district = district
//    }
    
    var body: some View {
        Form {
            //Uncomment for Mac App
//            Group {
//                Button(action: {
//                    self.viewModel.importCSV()
//                }) {
//                    Text("Import CSV")
//                }
//            }
            
            Section(header: Text("General")) {
                Group {
                    districtNameField
                    numPodPicker
                    startDatePicker
                }
            }
            
            Section(header: Text("District Information")){
                Group {
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
                    AddressSearchBar(labelText: "District Office Address", locationSearchService: locationSearchService)
                        .padding(.bottom, keyboard.currentHeight)
                }
            }
            
            Section {
                Group {
                    readyToInstallToggle
                }
            }
            
            NavigationLink(destination: ImplementationPlanView(district: self.$district)
            ) {
                Text("Implementation Plan")
                    .foregroundColor(Color.blue)
            }
            
            sendPodOrderButton
//            addDistrictButton
        }
            
        .navigationBarTitle("Add District")
        .navigationBarItems(leading: Image("Logo"), trailing: saveButton)
            
        .alert(isPresented: self.$isShowingAlert) {
            if self.addDistrictSuccess {
                return Alert(title: Text("Successfully Uploaded District Data"))
            } else if self.addDistrictFail {
                return Alert(title: Text("Failed to Upload District Data"))
            } else if self.isFieldsIncomplete {
                return Alert(title: Text("Please enter District Name"))
            } else {
                return Alert(title: Text("Something went wrong"))
            }
            
            
        }
        .onAppear() {
//            self.viewModel.implementationPlanListViewModel = self.implementationPlanViewModel
        }
    }
    
    //MARK: - Buttons
    var sendPodOrderButton: some View {
        //Button is red until email is valid
        SendPodOrderButtonView(numPods: district.numPodsNeeded , email: district.districtEmail , textColor: validateEmail(enteredEmail: district.districtEmail ) ? Color.green : Color.red)
    }
    
    var saveButton: some View {
        Button(action: {
            if self.district.districtName.isEmpty {
                self.isFieldsIncomplete = true
                self.isShowingAlert = true
                return
            }
            self.mainViewModel.uploadDistrict(district: self.district) { success in
                if success {
                    self.addDistrictSuccess = true
                    self.isShowingAlert = true
                } else {
                    self.addDistrictFail = true
                    self.isShowingAlert = true
                }
            }
        }) {
            Text("Save")
                .foregroundColor(Color.blue)
        }
    }
    
//    var addDistrictButton: some View {
//        Button(action: {
//            if self.formIsEmpty() {
//                self.isFieldsIncomplete = true
//                self.isShowingAlert = true
//                return
//            }
//            self.viewModel.uploadDistrict() { success in
//                if success {
//                    self.addDistrictSuccess = true
//                    self.isShowingAlert = true
//                } else {
//                    self.addDistrictFail = true
//                    self.isShowingAlert = true
//                }
//            }
//        }) {
//            Text("Add District")
//                .foregroundColor(self.formIsEmpty() ? Color.red : Color.green)
//        }
//    }
}

extension AddDistrictView {
    // MARK: - Form Items
    var numPodPicker: some View {
        VStack(alignment: .leading) {
            Text("Number of PODs Needed")
                .font(.headline)
            NumberField(placeholder: "Enter Number of PODs", text: self.$numPodsString, keyType: UIKeyboardType.numberPad)
                .onReceive(Just(self.numPodsString)) { newVal in
                    let filtered = newVal.filter {"0123456789".contains($0)}
                    if filtered != newVal {
                        self.numPodsString = filtered
                        self.district.numPodsNeeded = Int(filtered) ?? 0
                    }
            }
            .padding(.all)
        }
    }
    
    var startDatePicker: some View {
        VStack(alignment: .leading) {
            Text("Start Date")
                .font(.headline)
            
            DatePicker(selection: Binding<Date>(
                get: {self.district.startDate },
                set: {self.district.startDate = $0}), displayedComponents: .date) {
                    Text("")
            }
        }
    }
    
    var districtNameField: some View {
        VStack(alignment: .leading) {
            Text("District Name")
                .font(.headline)
            TextField("Enter District Name", text: Binding<String>(
                get: {self.district.districtName },
                set: {self.district.districtName = $0}
            ))
                .padding(.all)
        }
    }
    
    var numPreKSchoolsPicker: some View {
        VStack(alignment: .leading) {
            Text("Number of Pre-K Schools")
                .font(.headline)
            
            Picker(selection:
                Binding<Int>(
                    get: {self.district.numPreKSchools },
                    set: {self.district.numPreKSchools = $0}),
                   
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
                    get: {self.district.numElementarySchools },
                    set: {self.district.numElementarySchools = $0}),
                   
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
                    get: {self.district.numMiddleSchools },
                    set: {self.district.numMiddleSchools = $0}),
                   
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
                    get: {self.district.numHighSchools },
                    set: {self.district.numHighSchools = $0}),
                   
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
                get: {self.district.districtContactPerson },
                set: {self.district.districtContactPerson = $0}
            ))
                .padding(.all)
        }
    }
    
    var districtEmailField: some View {
        VStack(alignment: .leading) {
            Text("District Email")
                .font(.headline)
            TextField("Enter District Email", text: Binding<String>(
                get: {self.district.districtEmail },
                set: {self.district.districtEmail = $0}
            ))
                .padding(.all)
        }
    }
    
    var districtPhoneField: some View {
        VStack(alignment: .leading) {
            Text("District Phone Number")
                .font(.headline)
            TextField("Enter District Phone Number", text: Binding<String>(
                get: {self.district.districtPhoneNumber },
                set: {self.district.districtPhoneNumber = $0}
            ))
                .padding(.all)
        }
    }
    
    var readyToInstallToggle: some View {
        Toggle(isOn: Binding<Bool>(
            get: {(self.district.readyToInstall )},
            set: {self.district.readyToInstall = $0}
        ))  {
            Text("Ready To Install")
        }
    }
    
    func formIsEmpty() -> Bool {
        return district.districtContactPerson.isEmpty ||
            district.districtEmail.isEmpty ||
            district.districtPhoneNumber.isEmpty ||
            district.districtOfficeAddress == GeoPoint(latitude: 0, longitude: 0)
    }
}

//struct AddDistrictView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            AddDistrictView(with: District())
//        }
//    }
//}
