//
//  AddDistrictView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct AddDistrictView: View {
    @State var districtName: String = ""
    @State var numPreKSchools: Int = 0
    @State var numElementaryKSchools: Int = 0
    @State var numMiddleSchools: Int = 0
    @State var numHighSchools: Int = 0
    @State var districtContactName: String = ""
    @State var districtContactEmail: String = ""
    @State var districtContactPhone: String = ""
    @State var districtOfficeAddress: String = ""
    @State var assignedTeam: String = ""
    @State var numPods: Int = 0
    @State var startDate: Date = Date()
    
    
    var body: some View {
        NavigationView {
            // 3.
            Form {
                // 4.
                Section(header: Text("District Information")){
                    
                    formItem(with: $districtName, label: "District Name")
                    formItem(with: $numPreKSchools, label: "Number of Pre-K Schools")
                    formItem(with: $numElementaryKSchools, label: "Number of Elementary Schools")
                    formItem(with: $numMiddleSchools, label: "Number of Middle Schools")
                    formItem(with: $numHighSchools, label: "Number of High Schools")
                }
                
                Section(header: Text("General")) {
                    formItem(with: $numPods, label: "Number of Pods Needed")
                    formItem(with: $startDate, label: "Start Date")
                    
                }
                
                Section(header: Text("Contact Information")) {
                    formItem(with: $districtContactName, label: "District Contact Person")
                    formItem(with: $districtContactEmail, label: "District Contact Email")
                    formItem(with: $districtContactPhone, label: "District Contact Phone Number")
                    formItem(with: $districtOfficeAddress, label: "District Office Address")
                    formItem(with: $assignedTeam, label: "Asssigned Team")
                }
                
                
            } .navigationBarTitle("Add District")
        }
    }
    
    func formItem(with name: Binding<String>, label: String) -> some View {
        return VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
            TextField("Enter " + label, text: name)
                .padding(.all)
                .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
        }
        .padding(.horizontal, 15)
    }
    
    func formItem(with name: Binding<Int>, label: String) -> some View {
        return VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
            
            Picker(selection: name, label: Text(""), content: {
                ForEach(0..<100) {
                    Text("\($0)")
                }
            })
                .padding(.all)
                .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
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
//            Picker(selection: name, label: Text(""), content: {
//                ForEach(0..<100) {
//                    Text("\($0)")
//                }
//            })
//                .padding(.all)
//                .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
        }
        .padding(.horizontal, 15)
    }
    
    
}

struct AddDistrictView_Previews: PreviewProvider {
    static var previews: some View {
        AddDistrictView()
    }
}
