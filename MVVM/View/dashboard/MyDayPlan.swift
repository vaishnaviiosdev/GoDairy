
import SwiftUI

struct DayPlanView: View {
    @Binding var showSheet: Bool
    @State private var selectedWorkType: String = ""
    @State private var remarks: String = ""
    @StateObject var dashboardModel = dashboardViewModel()
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
            if showSheet {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showSheet = false
                        }
                    }

                VStack(spacing: 10) {
                    HStack {
                        Spacer()
                        ZStack {
                            Button(action: {
                                withAnimation { showSheet = false }
                            }) {
                                Image(systemName: "multiply")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.black)
                                    .padding(15)
                                    
                            }
                        }
                        .background(Circle().fill(Color.cancelBackground))
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 10)

                    Text("My Day Plan")
                        .font(.system(size: 25, weight: .medium))

                    Text("(\(formattedDate))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("WORK TYPE")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .fontWeight(.semibold)

                        Menu {
                            ForEach(dashboardModel.WorkTypeName, id: \.self) { type in
                                Button(type) {
                                    selectedWorkType = type
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedWorkType.isEmpty ? "Select" : selectedWorkType)
                                    .foregroundColor(.black)
                                    .fontWeight(.regular)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                        }
                    }
                    
                    Divider()
                        .background(Color.black)

                    VStack(alignment: .leading, spacing: 0) {
                        Text("REMARKS")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .fontWeight(.semibold)
                        
                        TextField(
                            text: $remarks,
                            prompt: Text("Type.....")
                                .foregroundColor(.gray)
                        ) {
                            EmptyView()
                        }
                        .padding()
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    }
                    Divider()
                        .background(Color.black)
                    Spacer(minLength: 12)

                    CustomBtn(title: "SUBMIT", height: 50, backgroundColor: Color.appPrimary) {
                        print("Submitted with: \(selectedWorkType), \(remarks)")
                        withAnimation { showSheet = false }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 400)
                .background(
                    Color.white
                        .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
                )
                .transition(.move(edge: .bottom))
                .animation(.spring(), value: showSheet)
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .onAppear {
            Task {
                await dashboardModel.fetchWorkTypeDataPost()
            }
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
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

#Preview {
    DayPlanView(showSheet: .constant(true))
}

