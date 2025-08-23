////
////  Test View.swift
////  GoDairy
////
////  Created by Anbu j on 28/09/24.
////
//
//import SwiftUI
//
//struct Login_Page_View: View {
//    @State private var username: String = ""
//    @State private var password: String = ""
//    @StateObject private var toastManager = ToastManager()
//
//    var body: some View {
//        ZStack {
//            VStack(spacing: 4) {
//                Color(red: 25/255, green: 151/255, blue: 206/255)
//                Color.white
//            }
//            .ignoresSafeArea()
//
//            Image("Group 15")
//                .resizable()
//                .scaledToFit()
//                .aspectRatio(contentMode: .fit)
//                .frame(minWidth: 0, maxWidth: .infinity, alignment: .top)
//                .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
//                .edgesIgnoringSafeArea(.all)
//
//            VStack {
//                HStack {
//                    VStack(alignment: .trailing, spacing: 1) {
//                        Text("Dairy product")
//                            .frame(maxWidth: .infinity, alignment: .trailing)
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .foregroundStyle(.white)
//                        Text("Delivery Solutions")
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .foregroundStyle(.white)
//                    }
//                    .padding()
//                }
//                Spacer(minLength: 200)
//
//                VStack {
//                    TextField("Username", text: $username)
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(3)
//                        .padding()
//
//                    SecureField("Password", text: $password)
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(3)
//                        .padding()
//                }
//                Spacer(minLength: 60)
//
//                NavigationLink(
//                    destination: page().toolbarRole(.editor),
//                    label: {
//                        forgetbtn().toolbarRole(.editor)
//                    }
//                )
//
//                // Pass toastManager to SignINbutton
//                SignINbutton(toastManager: toastManager)
//
//                Spacer(minLength: 50)
//
//                VStack(alignment: .center) {
//                    Text("Powered by")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                    Image("logopic")
//                        .resizable()
//                        .frame(width: 50, height: 50)
//                    Spacer(minLength: 50)
//                }
//            }
//        }
//
//        // Toast overlay
//        Toast(toastManager: toastManager)
//            .padding(.bottom, 50)
//    }
//}
//
//struct page: View {
//    @StateObject private var viewModel = DataViewModel()
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                List {
//                    Button("GET", action: {
//                        viewModel.fetchData()
//                    })
//
//                    ForEach(viewModel.data) { item in
//                        VStack(alignment: .leading) {
//                            Text("title: \(item.title)")
//                            Text("base_url: \(item.base_url)")
//                        }
//                    }
//                }
//                .navigationTitle("Custom List")
//            }
//        }
//    }
//}
//
//struct SignINbutton: View {
//    @ObservedObject var toastManager: ToastManager  // Receive ToastManager
//
//    var body: some View {
//        Text("SIGN IN")
//            .frame(width: 350, height: 50, alignment: .center)
//            .background(Color(red: 25/255, green: 151/255, blue: 206/255))
//            .font(.headline)
//            .foregroundColor(.white)
//            .cornerRadius(9)
//            .onTapGesture {
//                toastManager.showToast(message: "This is a toast message that will dismiss in 10 seconds")
//            }
//    }
//}
//
//struct forgetbtn: View {
//    var body: some View {
//        VStack(alignment: .trailing, spacing: 4) {
//            Text("Forget Password?")
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .font(.caption)
//                .foregroundColor(.primary)
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    Login_Page_View()
//}
