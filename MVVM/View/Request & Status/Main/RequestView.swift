

import SwiftUI

struct RequestView: View {
    @Environment(\.dismiss) var dismiss
    @State private var navigatetoDashboard = true
    
    // Reusable list of items
    private let requestItems: [(title: String, destination: AnyView)] = [
        ("Advance Request", AnyView(AdvanceRequestView())),
        ("Leave Request", AnyView(LeaveRequestView())),
        ("Permission Request", AnyView(PermissionRequestView())),
        ("Missed Punch", AnyView(MissedPunchView())),
        ("Weekly-Off", AnyView(weeklyOffView())),
        ("Deviation Entry", AnyView(DeviationEntryView()))
    ]
    
    private let StatusItems: [(title: String, destination: AnyView)] = [
        ("Advance Status",AnyView(LeaveStatusView())),
        ("Leave Status",AnyView(LeaveStatusView())),
        ("Permission Status",AnyView(LeaveStatusView())),
        ("Missed Punch Status",AnyView(missedPunchView())),
        ("Weekly-Off Status",AnyView(weeklyOffView())),
        ("Deviation Entry Status",AnyView(LeaveStatusView())),
        ("Leave Cancel Status",AnyView(LeaveCancelView()))
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar()
                    //.ignoresSafeArea(.all)
            ScrollView {
                VStack(spacing: 16) {
                    SectionCard(title: "REQUEST", items: requestItems)
                   
                    SectionCard(title: "STATUS", items: StatusItems)
                }
                .padding(.vertical, 8)
            }
            .background(Color(UIColor.systemGray6))
            .navigationBarTitleDisplayMode(.inline)
            Spacer()
            }
        }
        .ignoresSafeArea(.all)
        .navigationTitle("")
    }
}

// MARK: - Reusable Section Card
struct SectionCard: View {
    let title: String
    let items: [(title: String, destination: AnyView)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            titleCard(title: title, frameHeight: 40, fontSize: 14)
            
            ForEach(0..<items.count, id: \.self) { index in
                NavigationLink(destination: items[index].destination) {
                    RowView(title: items[index].title)
                        .onAppear() {
                            print("Row \(index) appeared")
                        }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct titleCard: View {
    let title: String
    let frameHeight: CGFloat
    let fontSize: CGFloat
    var body: some View {
        Text(title)
//            .font(.system(size: fontSize, weight: .heavy))
//            .foregroundColor(.white)
            .regularTextStyle(size: fontSize, foreground: .white, fontWeight: .heavy)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .frame(height: frameHeight)
            .background(Color.appPrimary)
    }
}

// MARK: - Reusable Row
struct RowView: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 8, height: 12)
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
                    .padding(.trailing)
            }
            .background(Color.white)
            Divider()
                .padding(.leading)
        }
    }
}

struct homeBar: View {
    var frameSize: CGFloat = 40
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
//            Button(action:{
//                dismiss()
//            }){
//                BackIcon(color: .white)
//                    .padding()
//            }
            Spacer()

            NavigationLink(destination: DashboardView()) {
                Image(systemName: "house.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(.trailing, 16)
            }
        }
        .frame(height: frameSize)
        .background(Color.appPrimary)
    }
}

#Preview {
    RequestView()
}
