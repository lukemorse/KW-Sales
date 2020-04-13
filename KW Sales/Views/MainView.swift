//
//  MainView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    //    @ObservedObject var viewModel: MainViewModel
    @State var selected = 0
    
    var body: some View {
        TabView(selection: $selected) {
            
            //Add District
            NavigationView {
                AddDistrictView()
                    .navigationBarTitle(Text("Main"), displayMode: .inline)
                    .navigationBarItems(leading:
                        Image("Logo")
                            .frame(height: nil)
                )
            }
            .tabItem({
                Image(systemName: Constants.TabBarImageName.tabBar0)
                    .font(.title)
                Text("\(Constants.TabBarText.tabBar0)")
            }).tag(0)
            
            //Pending
            NavigationView {
                PendingView()
                    .navigationBarTitle(
                        Text("Pending Installs"), displayMode: .inline)
                .navigationBarItems(leading:
                        Image("Logo")
                            .frame(height: nil)
                )
                
            }
            .tabItem({
                Image(systemName: Constants.TabBarImageName.tabBar1)
                    .font(.title)
                Text("\(Constants.TabBarText.tabBar1)")
            }).tag(1)
            
            //Completed
            NavigationView {
                CompletedView()
                    .navigationBarTitle(
                        Text("Completed Installs"), displayMode: .inline)
                .navigationBarItems(leading:
                        Image("Logo")
                            .frame(height: nil)
                )
            }
            .tabItem({
                Image(systemName: Constants.TabBarImageName.tabBar2)
                    .font(.title)
                Text("\(Constants.TabBarText.tabBar2)")
            }).tag(2)
            
            
        }.accentColor(Color.red)
            .onAppear(){
                //                self.viewModel.fetchTeamData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
