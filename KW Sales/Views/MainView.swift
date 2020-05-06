//
//  MainView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var selected = 0
    
    var body: some View {
        TabView(selection: $selected) {
            
            //Add District
            NavigationView {
                AddDistrictView()
                    .navigationBarTitle(Text("Add District"), displayMode: .inline)
                    .navigationBarItems(leading:
                        Image("Logo")
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem({
                Image(systemName: Constants.TabBarImageName.tabBar0)
                    .font(.title)
                Text("\(Constants.TabBarText.tabBar0)")
            }).tag(0)
            
            
            //Pending
            NavigationView {
                PendingListView()
                    .navigationBarTitle(
                        Text("Pending Installs"), displayMode: .inline)
                    .navigationBarItems(leading:
                        Image("Logo")
                            .frame(height: nil)
                )
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem({
                Image(systemName: Constants.TabBarImageName.tabBar1)
                    .font(.title)
                Text("\(Constants.TabBarText.tabBar1)")
            }).tag(1)
            
            //Completed
            NavigationView {
                CompletedListView()
                    .navigationBarTitle(
                        Text("Completed Installs"), displayMode: .inline)
                    .navigationBarItems(leading:
                        Image("Logo")
                            .frame(height: nil)
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem({
                Image(systemName: Constants.TabBarImageName.tabBar2)
                    .font(.title)
                Text("\(Constants.TabBarText.tabBar2)")
            }).tag(2)
            
            
        }.accentColor(Color.red)
            .onAppear(){
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
