
import SwiftUI

struct DayPlanView: View {
    @Binding var showSheet: Bool
    @State private var selectedWorkType: String = ""
    @State private var remarks: String = ""
    //@State private var showSheet: Bool = true
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
            Color.clear
            VStack {
                Spacer()
                if showSheet {
                    VStack(spacing: 3) {
                       // Spacer(minLength: 10)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                            //withAnimation {
                                showSheet = false
                            //}
                            }) {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Text("My Day Plan")
                            .font(.system(size: 25,weight: .medium))
                        
                        Text("(\(formattedDate))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("WORK TYPE")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .fontWeight(.bold)
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
                                        .fontWeight(.medium)
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
                                .fontWeight(.bold)
                            
                            TextField("Type.....", text: $remarks)
                                .padding()
                                .foregroundColor(Color.gray)
                                .fontWeight(.bold)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        Spacer(minLength: 10)
                        CustomBtn(title: "SUBMIT", height: 50, backgroundColor: Color.appPrimary) {
                            print("Submitted with: \(selectedWorkType), \(remarks)")
                            showSheet = false
                            //withAnimation {
                                showSheet = false
                            //}
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    //.frame(height: 400)
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

#Preview {
    DayPlanView(showSheet: .constant(true))
}

