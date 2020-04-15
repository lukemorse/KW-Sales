////
////  TestSchoolType.swift
////
////
////  Created by Luke Morse on 4/15/20.
////
//
//import SwiftUI
//
//enum MyEnum {
//    case firstCase
//    case secondCase
//
//    var description: String {
//        switch self {
//        case .firstCase: return "first case"
//        case .secondCase: return "second case"
//        }
//    }
//}
//
//struct TestSchoolType: View {
//    @State var selection: MyEnum = .firstCase
//    var body: some View {
//        formItem(with: $selection, label: "choose type")
//    }
//
//    func formItem(with type: Binding<MyEnum>, label: String) -> some
//            View {
//                return VStack(alignment: .leading) {
//                    Text(label)
//                        .font(.headline)
//                    TextField("Enter " + label, text: type)
//                        .padding(.all)
//
//                }
//                .padding(.horizontal, 15)
//        }
//}
//
//struct TestSchoolType_Previews: PreviewProvider {
//    static var previews: some View {
//        TestSchoolType()
//    }
//}
