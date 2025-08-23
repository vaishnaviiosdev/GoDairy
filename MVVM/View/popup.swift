//
//  popup.swift
//  GoDairy
//
//  Created by San eforce on 15/11/24.
//
import SwiftUI
struct Content: View {
    @State private var showDayPlan = false
    
    
    var body: some View {
        NavigationStack{
            VStack {
                Button("MY Day Plan") {
                    showDayPlan.toggle()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .sheet(isPresented: $showDayPlan, content: {
                ModalView(isPresented: $showDayPlan)
                    .presentationDetents([.height(700)])
            })
                    
                
            }
        }
    }

#Preview {
    Content()
}
/*import SwiftUI

struct BottomSheetView: View {
    @State private var isPresented = false
    @State private var workType: String = ""
    @State private var remarks: String = ""
    @State private var navigatetoDashboard = false
    @State private var currentDate = Date()

    var body: some View {
        ZStack {
            // Background
          /*  if isPresented {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }
            }*/
            
            // Bottom Sheet
            if isPresented {
                VStack {
                    Spacer()

                    ZStack {
                        VStack(spacing: 20) {
                            HStack {
                                Spacer()
                                    .frame(height: 250)
                                Button(action: {
                                    withAnimation {
                                        isPresented = false
                                    }
                                }) {
                                    ZStack{
                                        Spacer()
                                        Circle()
                                            .foregroundColor(Color(white: 0.9))
                                            .frame(width: 40, height: 40)
                                        Image(systemName: "xmark")
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(.black)
                                            .padding()
                                    }
                                }
                              //  Spacer()
                                    //.frame(width: 20)
                            }
                            
                            Text("My Day Plan")
                                .font(.headline)
                                .foregroundColor(.black)
                            Text("(\(formattedDate(currentDate)))")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("WORK TYPE")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Menu {
                                    Button("w1") { workType = "w1" }
                                    Button("w2") { workType = "w2" }
                                    Button("w3") { workType = "w3" }
                                } label: {
                                    HStack {
                                        Text(workType.isEmpty ? "Select" : workType)
                                            .foregroundColor(workType.isEmpty ? .gray : .black)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("REMARKS")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                TextField("Type...", text: $remarks)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal)
                            
                            Button(action: {
                                navigatetoDashboard = true
                                withAnimation {
                                    isPresented = false
                                }
                            }) {
                                Text("SUBMIT")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(colorData.shared.Appcolor) // Replace with your Appcolor
                                    .cornerRadius(8)
                            }
                            Spacer()
                                .frame(height: 300)
                            
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .frame(height: 700)
                    .background(Color.white)
                    .cornerRadius(30)
                    .padding()
                    .transition(.move(edge: .bottom)) // Make the bottom sheet slide up from the bottom
                }
                .zIndex(1)
            }
            
            // Navigation Link to Dashboard
            NavigationLink(
                destination: checkInDashboard(), // Replace with your dashboard view
                isActive: $navigatetoDashboard
            ) {
                EmptyView()
            }
        }
        .onAppear {
            // Simulate the sheet being presented
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    isPresented = true
                }
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}

struct ContentViews: View {
    @State private var showingCredits = false
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Show Bottom Sheet") {
                    // Present the bottom sheet
                    showingCredits.toggle()
                }
                .sheet(isPresented: $showingCredits) {
                    BottomSheetView()
                                .presentationDetents([.medium, .large])
                        }
            }
        }
    }
}

#Preview {
    ContentViews()
}*/

/*struct ContentView5: View {
    @Binding var isPresented: Bool
    @State private var workType: String = ""
    @State private var remarks: String = ""
    let currentDate = Date()
    @State private var navigatetoDashboard = true
    

    @State private var showingCredits = false

    let heights = stride(from: 0.1, through: 5.0, by: 0.1).map { PresentationDetent.fraction($0) }

    var body: some View {
        Button("Show Credits") {
            showingCredits.toggle()
        }
        .sheet(isPresented: $showingCredits) {
            Image(systemName: "xmark")
            ZStack{
                VStack(spacing: 20) {
                    /*Circle()
                     .fill(colorData.shared.Appcolor)
                     .frame(width: 60, height: 60)
                     .overlay(
                     // Image(systemName: "calendar.badge.clock")
                     Image("Group 17")
                     .foregroundColor(.white)
                     .font(.system(size: 24))
                     )*/
                    HStack {
                        Spacer()
                            .frame(height: 250)
                        Button(action: {
                            isPresented = false
                        }) {
                            
                            ZStack{
                                Circle()
                                    .foregroundColor(Color(white:0.9))
                                    .frame(width: 40,height: 40)
                                Image(systemName: "xmark")
                                    .frame(width: 10,height: 10)
                                    .foregroundColor(.black)
                                    .padding()
                            }
                        }
                        Spacer()
                            .frame(width: 20)
                    }
                    
                    
                    
                    
                    Text("My Day Plan")
                        .font(.headline)
                        .foregroundColor(.black)
                    Text("(\(formattedDate(currentDate)))")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("WORK TYPE")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Menu {
                            Button("w1") { workType = "w1" }
                            Button("w2") { workType = "w2" }
                            Button("w3") { workType = "w3" }
                        } label: {
                            HStack {
                                Text(workType.isEmpty ? "Select" : workType)
                                    .foregroundColor(workType.isEmpty ? .gray : .black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                                
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("REMARKS")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        TextField("Type...", text: $remarks)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    
                    Button(action: {
                        
                        navigatetoDashboard = true
                        isPresented = false
                    }) {
                        Text("SUBMIT")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(colorData.shared.Appcolor)
                            .cornerRadius(8)
                    }
                    
                }
                .padding(.horizontal)
                
                Spacer()
            }
                .presentationDetents(Set(heights))
        }
    }
}
private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter.string(from: date)
}


#Preview {
    ContentView5(isPresented: <#Binding<Bool>#>)
}*/

/*struct ModalView: View {
    @State var presentSheet = false
    
    var body: some View {
        NavigationView {
            Button("Modal") {
                presentSheet = true
            }
            .navigationTitle("Main")
        }.sheet(isPresented: $presentSheet) {
            Text("Detail")
                .presentationDetents([.medium, .large])

        }
    }
}
*/





/*import SwiftUI

struct ModalView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.ignoresSafeArea(edges: .all)
                
                ScrollView {
                    Text("Hello from the modal view!")
                        .bold()
                        .foregroundStyle(.white)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close", systemImage: "xmark") {
                        dismiss()
                    }
                    .tint(.white)
                }
            }
        }
    }
}
struct DynamicDetentHeight: CustomPresentationDetent {
    static func height(in context: Context) -> CGFloat? {
        switch context.dynamicTypeSize {
        case .accessibility1:
            return 120
        case .accessibility2:
            return 140
        case .accessibility3:
            return 160
        case .accessibility4:
            return 180
        case .accessibility5:
            return 200
        default:
            return 100
        }
    }
}

extension PresentationDetent {
    static let dynamicDetent = Self.custom(DynamicDetentHeight.self)
}
*/
/*#Preview {
    ModalView()
}
*/
