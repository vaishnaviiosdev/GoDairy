////
////  MyDayPlan.swift
////  GoDairy
////
////  Created by San eforce on 14/11/24.
////
//
//import SwiftUI
//
//struct MyDayPlanView: View {
//    
//    //@Binding var isPresented: Bool
//    @State private var workType: String = ""
//    @State private var remarks: String = ""
//    @State private var navigateToDashboard = false
//    let currentData = Date()
//    
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                HStack {
//                    Spacer()
//                        .frame(height: 250)
//                    Button(action: {
//                        navigateToDashboard = true
//                    }) {
//                        
//                        ZStack{
//                            Spacer()
//                            Circle()
//                                .foregroundColor(Color(white:0.9))
//                                .frame(width: 40,height: 40)
//                            Image(systemName: "xmark")
//                                .frame(width: 10,height: 10)
//                                .foregroundColor(.black)
//                            .padding()
//                        }
//                    }
//                    // Spacer()
//                    //   .frame(width: 20)
//                }
//                
//                
//                
//                Text("My Day Plan")
//                    .font(.title)
//                    .padding(.top)
//
//                Text(formattedDate(Date()))
//                    .foregroundColor(.gray)
//
//                Spacer()
//
//                VStack(alignment: .leading, spacing: 16) {
//                    Text("WORK TYPE")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//
//                    Menu {
//                        Button("w1") { workType = "w1" }
//                        Button("w2") { workType = "w2" }
//                        Button("w3") { workType = "w3" }
//                    } label: {
//                        HStack {
//                            Text(workType.isEmpty ? "Select" : workType)
//                                .foregroundColor(workType.isEmpty ? .gray : .primary)
//                            Spacer()
//                            Image(systemName: "chevron.down")
//                                .foregroundColor(.gray)
//                        }
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(8)
//                    }
//
//                    Text("REMARKS")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//
//                    TextField("Type...", text: $remarks)
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(8)
//                }
//                .padding(.horizontal)
//
//                Spacer()
//
//                Button(action: {
//                    navigateToDashboard = true
//                   // isPresented = false
//                }) {
//                    Text("SUBMIT")
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color("App_Primary"))
//                        .cornerRadius(8)
//                }
//                .padding(.horizontal)
//
//                NavigationLink(
//                    destination: checkInDashboard(),
//                    isActive: $navigateToDashboard
//                ) {
//                    EmptyView()
//                }
//            }
//            .padding()
//        }
//    }
//
//    private func formattedDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yyyy"
//        return formatter.string(from: date)
//    }
//}
//
//#Preview {
//    MyDayPlanView()
//}
//
//
//
import SwiftUI

struct DayPlanView: View {
    @State private var selectedWorkType: String = ""
    @State private var remarks: String = ""
    @State private var showSheet: Bool = true
    @StateObject var viewModel = ProductViewModel()
    @Environment(\.dismiss) var dismiss
    let currentDate = Date()
    
    let workTypes = ["Select","Field Work", "Special Project", "Review Meeting", "New Distributor Search", "Leave", "Weekly Off"]
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: currentDate)
    }
    
    var body: some View {
        ZStack {
            Color.secondary
            VStack {
//                Button(action: {
//                    dismiss()
//                }) {
//                    Spacer()
//                    Image(systemName: "multiply")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 25, height: 25)
//                        .foregroundColor(Color.white)
//                        .padding()
//                }
                Spacer()
                if showSheet {
                    VStack(spacing: 20) {
                        Text("My Day Plan")
                            .font(.title2)
                            .font(.system(size: 18,weight: .medium))
                        
                        Text(formattedDate)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading, spacing: 6) { // Work Type Picker
                            Text("WORK TYPE")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Menu {
                                ForEach(workTypes, id: \.self) { type in
                                    Button(type) {
                                        selectedWorkType = type
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedWorkType.isEmpty ? "Select" : selectedWorkType)
                                        .foregroundColor(.black)
                                        .fontWeight(.light)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 6) { // Remarks TextField
                            Text("REMARKS")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            TextField("Type.....", text: $remarks)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                        }
                        
                        Spacer()
                        CustomBtn(title: "SUBMIT", height: 50, backgroundColor: Color.appPrimary) {
                            print("Submitted with: \(selectedWorkType), \(remarks)")
                            showSheet = false
                        }
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 400)
                    .background(Color.white)
                    .cornerRadius(40, corners: [.topLeft, .topRight])
                    .transition(.move(edge: .bottom))
                    .animation(.spring(), value: showSheet)
                    .ignoresSafeArea(edges: .bottom)
                }
               
            }
        }
        .onAppear {
            Task {
                await viewModel.getWorkTypesData(sf: sf_code, div: division_code)
            }
        }
    }
}

#Preview {
    DayPlanView()
}

// Helper for corner radius on specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 0.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

