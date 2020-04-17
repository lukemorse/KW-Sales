//
//  CreateImplementationPlanView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct CreateImplementationPlanView: View {
    //        @ObservedObject var viewModel = AddDistrictViewModel()
    @State private var isExpanded: Bool = true
    @State var schoolName: String = ""
    @State var schoolType: SchoolType = .preKSchool
    @State var numFloors: Int = 0
    @State var numRooms: Int = 0
    @State var numPods: Int = 0
    @State var schoolContactName: String = ""
    let installation: Installation
    
    var body: some View {
            content
    }
    
    private var content: some View {
//        VStack(alignment: .leading) {
//            Text("School 1")
                
                    Section {
                        Text(schoolName)
                        .onTapGesture {
                            self.isExpanded.toggle()
                        }
                        if isExpanded {
                            formItem(with: $schoolName, label: "School Name")
                            formItem(with: $schoolType, label: "School Type")
                            formItem(with: $numFloors, label: "Number of Floors")
                            formItem(with: $numRooms, label: "Number of Rooms")
                            formItem(with: $numPods, label: "Number of Pods")
                            formItem(with: $schoolContactName, label: "School Contact Person")
                            
                            Button(action: {
                                // floor plan
                            }) {
                                Text("Upload Floor Plan")
                            }
                            Button(action: {
                                ///pod map
                            }) {
                                Text("Create POD Map")
                            }
                        }
                        
                    }
                    
                
                //                        .navigationBarTitle("Implementation Plan")
            
//        }
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
                Picker(selection: $schoolType, label: Text("School Type")) {
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
        CreateImplementationPlanView(installation: testInstallArray[0])
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
