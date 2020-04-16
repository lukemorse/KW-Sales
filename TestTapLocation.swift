//
//  TestTapLocation.swift
//  KW Sales
//
//  Created by Luke Morse on 4/16/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct TappableView: UIViewRepresentable
{
    var tapCallback: (UILongPressGestureRecognizer) -> Void

    typealias UIViewType = UIView

    func makeCoordinator() -> TappableView.Coordinator
    {
        Coordinator(tapCallback: self.tapCallback)
    }

    func makeUIView(context: UIViewRepresentableContext<TappableView>) -> UIView
    {
        let view = UIView()
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(sender:))))
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<TappableView>)
    {
    }

    class Coordinator
    {
        var tapCallback: (UILongPressGestureRecognizer) -> Void

        init(tapCallback: @escaping (UILongPressGestureRecognizer) -> Void)
        {
            self.tapCallback = tapCallback
        }

        @objc func handleTap(sender: UILongPressGestureRecognizer)
        {
            
            self.tapCallback(sender)
        }
    }
}

//
//struct TestTapLocation_Previews: PreviewProvider {
//    static var previews: some View {
//        TappableView(tapCallback: <#(UITapGestureRecognizer) -> Void#>)
//    }
//}


//
//struct TapView : View {
//    @State var points:[CGPoint] = [CGPoint(x:0,y:0), CGPoint(x:50,y:50)]
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            Background {
//                   // tappedCallback
//                   location in
//                    self.points.append(location)
//                print(location)
//                }
//                .background(Color.white)
////        ForEach(self.points, id: \.self) {
////                point in
////                Color.red
////                    .frame(width:50, height:50, alignment: .center)
////                    .offset(CGSize(width: point.x, height: point.y))
////            }
//        }
//    }
//}
//
//struct Background:UIViewRepresentable {
//    var tappedCallback: ((CGPoint) -> Void)
//
//    func makeUIView(context: UIViewRepresentableContext<Background>) -> UIView {
//        let v = UIView(frame: .zero)
//        let gesture = UITapGestureRecognizer(target: context.coordinator,
//                                             action: #selector(Coordinator.tapped))
//        v.addGestureRecognizer(gesture)
//        return v
//    }
//
//    class Coordinator: NSObject {
//        var tappedCallback: ((CGPoint) -> Void)
//        init(tappedCallback: @escaping ((CGPoint) -> Void)) {
//            self.tappedCallback = tappedCallback
//        }
//        @objc func tapped(gesture:UITapGestureRecognizer) {
//            let point = gesture.location(in: gesture.view)
//            self.tappedCallback(point)
//        }
//    }
//
//    func makeCoordinator() -> Background.Coordinator {
//        return Coordinator(tappedCallback:self.tappedCallback)
//    }
//
//    func updateUIView(_ uiView: UIView,
//                       context: UIViewRepresentableContext<Background>) {
//    }
//
//}
//
//struct TestTapLocation_Previews: PreviewProvider {
//    static var previews: some View {
//        TapView()
//    }
//}


