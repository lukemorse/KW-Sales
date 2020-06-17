//
//  AddressPicker.swift
//  KW Sales
//
//  Created by Luke Morse on 6/3/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct AddressPicker: View {
    let label: String
    let callback: (String) -> ()
    var body: some View {
        AddressSearchBar(labelText: label) { address in
            self.callback(address)
        }
    .padding(30)
    }
}
//
//struct AddressPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        let locationSearchService = LocationSearchService()
//        return AddressPicker(locationSearchService: locationSearchService, label: "School Address") {
//            address in
//            print(address)
//        }
//    }
//}

