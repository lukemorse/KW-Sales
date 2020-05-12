//
//  AddressSearchBar.swift
//  KW Sales
//
//  Created by Luke Morse on 5/6/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import MapKit
import Combine

struct SearchBar: UIViewRepresentable {

    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {
        
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

// MARK: - LocationSearchService
class LocationSearchService: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchQuery = ""
    var completer: MKLocalSearchCompleter
    @Published var completions: [MKLocalSearchCompletion] = []
    var cancellable: AnyCancellable?
    
    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        cancellable = $searchQuery.assign(to: \.queryFragment, on: self.completer)
        completer.delegate = self
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.completions = completer.results
    }
}

extension MKLocalSearchCompletion: Identifiable {}

struct AddressSearchBarContainer: View {
    @ObservedObject var locationSearchService: LocationSearchService
    
    var body: some View {
        VStack {
            SearchBar(text: $locationSearchService.searchQuery)
            List(locationSearchService.completions) { completion in
                VStack(alignment: .leading) {
                    Text(completion.title)
                    Button(completion.subtitle) {
                        let address = completion.subtitle
                        self.locationSearchService.searchQuery = address
                        self.locationSearchService.completions = []
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                        
                        let geoCoder = CLGeocoder()
                        geoCoder.geocodeAddressString(address) { (placemarks, error) in
                            guard
                                let placemarks = placemarks,
                                let location = placemarks.first?.location
                            else {
                                // handle no location found
                                return
                            }
//                            location.coordinate.

                            // Use your location
                        }
                    }
                    Text(completion.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct AddressSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        AddressSearchBarContainer(locationSearchService: LocationSearchService())
    }
}
