////
////  TestDragDropView.swift
////  KW Sales
////
////  Created by Luke Morse on 7/7/20.
////  Copyright © 2020 Luke Morse. All rights reserved.
////
//
//import SwiftUI
//import AppKit
//
//struct InputView: View {
//
//    @Binding var image: NSImage?
//
//    var body: some View {
//        VStack(spacing: 16) {
//            HStack {
//                Text("Input Image (PNG,JPG,JPEG,HEIC)")
//                Button(action: selectFile) {
//                    Text("From Finder")
//                }
//            }
//            InputImageView(image: self.$image)
//        }
//    }
//
//    private func selectFile() {
//        NSOpenPanel.openImage { (result) in
//            if case let .success(image) = result {
//                self.image = image
//            }
//        }
//    }
//}
//
//struct InputImageView: View {
//
//    @Binding var image: NSImage?
//
//    var body: some View {
//        ZStack {
//            if self.image != nil {
//                Image(nsImage: self.image!)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//            } else {
//                Text("Drag and drop image file")
//                    .frame(width: 320)
//            }
//        }
//        .frame(height: 320)
//        .background(Color.black.opacity(0.5))
//        .cornerRadius(8)
//
//        .onDrop(of: ["public.url","public.file-url"], isTargeted: nil) { (items) -> Bool in
//            if let item = items.first {
//                if let identifier = item.registeredTypeIdentifiers.first {
//                    print("onDrop with identifier = \(identifier)")
//                    if identifier == "public.url" || identifier == "public.file-url" {
//                        item.loadItem(forTypeIdentifier: identifier, options: nil) { (urlData, error) in
//                            DispatchQueue.main.async {
//                                if let urlData = urlData as? Data {
//                                    let urll = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
//                                    if let img = NSImage(contentsOf: urll) {
//                                        self.image = img
//                                        print("got it")
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                return true
//            } else { print("item not here") return false }
//        }
//    }
//}
//
//
//struct TestDragDropView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestDragDropView()
//    }
//}
//
//
//extension NSOpenPanel {
//
//    static func openImage(completion: @escaping (_ result: Result<NSImage, Error>) -> ()) {
//        let panel = NSOpenPanel()
//        panel.allowsMultipleSelection = false
//        panel.canChooseFiles = true
//        panel.canChooseDirectories = false
//        panel.allowedFileTypes = ["jpg", "jpeg", "png", "heic"]
//        panel.canChooseFiles = true
//        panel.begin { (result) in
//            if result == .OK,
//                let url = panel.urls.first,
//                let image = NSImage(contentsOf: url) {
//                completion(.success(image))
//            } else {
//                completion(.failure(
//                    NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get file location"])
//                ))
//            }
//        }
//    }
//}
