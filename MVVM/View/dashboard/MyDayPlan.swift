
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
    
//    var body: some View {
//        ZStack {
//            Color.black.opacity(0.4)
//            VStack {
//                Spacer()
//                if showSheet {
//                    VStack(spacing: 5) {
//                        Spacer(minLength: 10)
//                        Text("My Day Plan")
//                            .font(.system(size: 16,weight: .medium))
//                        
//                        Text(formattedDate)
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                        
//                        VStack(alignment: .leading, spacing: 6) {
//                            Text("WORK TYPE")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                            Menu {
//                                ForEach(workTypes, id: \.self) { type in
//                                    Button(type) {
//                                        selectedWorkType = type
//                                    }
//                                }
//                            } label: {
//                                HStack {
//                                    Text(selectedWorkType.isEmpty ? "Select" : selectedWorkType)
//                                        .foregroundColor(.black)
//                                        .fontWeight(.light)
//                                    Spacer()
//                                    Image(systemName: "chevron.down")
//                                        .foregroundColor(.gray)
//                                }
//                                .padding()
//                                .background(
//                                    RoundedRectangle(cornerRadius: 6)
//                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
//                                )
//                            }
//                        }
//                        
//                        VStack(alignment: .leading, spacing: 6) { // Remarks TextField
//                            Text("REMARKS")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                            
//                            TextField("Type.....", text: $remarks)
//                                .padding()
//                                .background(
//                                    RoundedRectangle(cornerRadius: 6)
//                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
//                                )
//                        }
//                        Spacer()
//                        CustomBtn(title: "SUBMIT", height: 50, backgroundColor: Color.appPrimary) {
//                            print("Submitted with: \(selectedWorkType), \(remarks)")
//                            showSheet = false
//                        }
//                    }
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 400)
//                    .background(Color.white)
//                    .cornerRadius(40, corners: [.topLeft, .topRight])
//                    .transition(.move(edge: .bottom))
//                    .animation(.spring(), value: showSheet)
//                    .ignoresSafeArea(edges: .bottom)
//                }
//            }
//            Circle()
//                .fill(Color.clear)
//                .frame(width: 80, height: 80)
//                .overlay(
//                    Image("Group 17")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 140, height: 140)
//                )
//        }
//        .onAppear {
//            Task {
//                await viewModel.getWorkTypesData(sf: sf_code, div: division_code)
//            }
//        }
//    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack {
                Spacer()
                if showSheet {
                    ZStack(alignment: .top) {
                        VStack(spacing: 5) {
                            Spacer(minLength: 50)
                            Text("My Day Plan")
                                .font(.system(size: 16, weight: .medium))

                            Text(formattedDate)
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            VStack(alignment: .leading, spacing: 6) {
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

                            VStack(alignment: .leading, spacing: 6) {
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

                        Circle()
                            .fill(Color.appPrimary) // Blue background instead of white (optional)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image("Group 17")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white) // if you want the icon white
                            )
                            .shadow(radius: 4)
                            .offset(y: -40)
                    }
                    .background(Color.black)
                }
                //.background(.blue)
            }
        }
    }


}

#Preview {
    DayPlanView()
}

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

