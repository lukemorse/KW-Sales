//
//  CreateImplementationPlanView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import Firebase

struct CreateInstallationView: View {
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let index: Int
    @ObservedObject var viewModel: InstallationViewModel
    @State private var isExpanded: Bool = true
    
    var body: some View {
        Section {
            Text(viewModel.installation.schoolName)
//                .onReceive(timer) { input in
//                    print(self.viewModel.Installation)
//                }
                .onTapGesture {
                    self.isExpanded.toggle()
            }
            
            if isExpanded {
                
//                VStack(alignment: .leading) {
//                    Text("School Name")
//                        .font(.headline)
//                    TextField("Enter School Name", text: $viewModel.Installation.schoolName)
//                        .padding([.top, .bottom])
//
//                }
                
                formItem(with: $viewModel.installation.schoolName, label: "School Name")
                
//                formItem(with: $schoolName, label: "School Name")
                formItem(with: $viewModel.installation.schoolType, label: "School Type")
                formItem(with: $viewModel.installation.numFloors, label: "Number of Floors")
                formItem(with: $viewModel.installation.numRooms, label: "Number of Rooms")
                formItem(with: $viewModel.installation.numPods, label: "Number of Pods")
                formItem(with: $viewModel.installation.schoolContact, label: "School Contact Person")
                
                NavigationLink(destination: CreatePodMapView(viewModel: self.viewModel)) {
                    Text("Create POD Map")
                        .foregroundColor(Color.blue)
                }
            }
        }
        
    }
    
    func getInstallation() -> Installation {
        return viewModel.installation
    }
    
    //Funcs for adding form items
    
    func formItem(with name: Binding<String>, label: String) -> some
        View {
            return VStack(alignment: .leading) {
                Text(label)
                    .font(.headline)
                TextField("Enter " + label, text: name)
                    .padding([.top, .bottom])
                
            }
            
    }
    
    func formItem(with schoolType: Binding<SchoolType>, label: String) -> some
        View {
            return VStack(alignment: .leading) {
                Text(label)
                    .font(.headline)
                Picker(selection: $viewModel.installation.schoolType, label: Text("School Type")) {
                    ForEach(SchoolType.allCases) { school in
                        Text(school.description).tag(school)
                    }
                }
                .padding([.top, .bottom])
                
            }
            
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
                    .padding([.top, .bottom])
            }
            
    }
    
    func formItem(with name: Binding<Date>, label: String) -> some View {
        return VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
            DatePicker(selection: name, displayedComponents: .date) {
                Text("")
            }
        }
        
    }
    
}

struct CreateImplementationPlan_Previews: PreviewProvider {
    static var previews: some View {
        CreateInstallationView(index: 0, viewModel: InstallationViewModel(installation: Installation(statusCode: 0, schoolType: .elementary, address: chicagoGeoPoint, districtContact: "", districtName: "", schoolContact: "", schoolName: "", email: "", numFloors: 0, numRooms: 0, numPods: 0, timeStamp: Timestamp(), podMaps: [])))
        //            .environment(\.colorScheme, .dark)
    }
}

enum SchoolType: Int, Codable, CaseIterable, Hashable, Identifiable {
    var id: Int { hashValue }
    
    case preKSchool
    case elementary
    case middleSchool
    case highSchool
    
    var description: String {
        switch self {
        case .preKSchool: return "Pre K School"
        case .elementary: return "Elementary School"
        case .middleSchool: return "Middle School"
        case .highSchool: return "High School"
        }
    }
}
