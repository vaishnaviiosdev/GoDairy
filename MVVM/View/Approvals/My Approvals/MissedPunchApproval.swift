//
//  MissedPunchApproval.swift
//  GoDairy
//
//  Created by San eforce on 11/09/25.
//

import SwiftUI

struct MissedPunchApprovalData: Identifiable {
    let id = UUID()
    let name: String
    let appliedDate: String
}

struct MissedPunchApproval: View {
    
    @State private var approvals: [MissedPunchApprovalData] = [
        MissedPunchApprovalData(name: "G RAMESH", appliedDate: "10-09-2025"),
        MissedPunchApprovalData(name: "G RAMESH", appliedDate: "24-01-2025"),
        MissedPunchApprovalData(name: "G RAMESH", appliedDate: "12-02-2025"),
        MissedPunchApprovalData(name: "G RAMESH", appliedDate: "25-01-2025"),
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                MissedApprovalSectionCard(title: "MISSED PUNCH APPROVAL")
                
                GeometryReader { geo in
                    let totalWidth = geo.size.width - 32 // account for paddings
                    let nameWidth = totalWidth * 0.4      // 40%
                    let dateWidth = totalWidth * 0.3      // 30%
                    let actionWidth = totalWidth * 0.3    // 30%
                    
                    VStack(spacing: 0) {
                        // Header
                        HStack {
                            Text("Name")
                                .font(.system(size: 14, weight: .medium))
                                .frame(width: nameWidth, alignment: .leading)
                            
                            Text("Applied date")
                                .font(.system(size: 14, weight: .medium))
                                .frame(width: dateWidth, alignment: .center)
                            
                            Text("Click here")
                                .font(.system(size: 14, weight: .medium))
                                .frame(width: actionWidth, alignment: .trailing)
                        }
                        .padding(.horizontal, 10)
                        .background(.backgroundPink)
                        
                        // Data rows
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(approvals) { item in
                                    HStack {
                                        Text(item.name)
                                            .font(.system(size: 14))
                                            .frame(width: nameWidth, alignment: .leading)
                                        
                                        Text(item.appliedDate)
                                            .font(.system(size: 14))
                                            .frame(width: dateWidth, alignment: .center)
                                        
                                        Button(action: {
                                            print("View tapped for \(item.name)")
                                        }) {
                                            Text("View")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 30)
                                                .background(Color.blue)
                                                .cornerRadius(6)
                                        }
                                        .frame(width: actionWidth, alignment: .trailing)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    
                                    Divider()
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


//struct MissedPunchApproval: View {
//    
//    @State private var approvals: [MissedPunchApprovalData] = [
//        MissedPunchApprovalData(name: "G RAMESH", appliedDate: "10-09-2025"),
//        MissedPunchApprovalData(name: "G RAMESH", appliedDate: "24-01-2025"),
//        MissedPunchApprovalData(name: "G RAMESH", appliedDate: "12-02-2025"),
//        MissedPunchApprovalData(name: "G RAMESH", appliedDate: "25-01-2025"),
//    ]
//    var body: some View {
//        NavigationStack {
//            VStack {
//                homeBar(frameSize: 40)
//                MissedApprovalSectionCard(title: "MISSED PUNCH APPROVAL")
//                HStack() {
//                        Text("Name")
//                            .font(.system(size: 14))
//                            .foregroundColor(.black)
//                            .fontWeight(.medium)
//                            .multilineTextAlignment(.center)
//                        Spacer()
//                        Text("Applied date")
//                            .font(.system(size: 14))
//                            .foregroundColor(.black)
//                            .fontWeight(.medium)
//                            .multilineTextAlignment(.center)
//                        Spacer()
//                        Text("Click here")
//                            .font(.system(size: 14))
//                            .foregroundColor(.black)
//                            .fontWeight(.medium)
//                            .multilineTextAlignment(.center)
//                    }
//                    .padding(.horizontal, 10)
//                    .background(.backgroundPink)
//                
//                ScrollView {
//                    VStack(spacing: 0) {
//                        ForEach(approvals) { item in
//                            HStack(alignment: .center) {
//                                Text(item.name)
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .font(.system(size: 14))
//                                
//                                Text(item.appliedDate)
//                                    .frame(maxWidth: .infinity, alignment: .center)
//                                    .font(.system(size: 14))
//                                
//                                Button(action: {
//                                    // Navigate or show details
//                                    print("View tapped for \(item.name)")
//                                }) {
//                                    Text("View")
//                                        .font(.system(size: 14, weight: .semibold))
//                                        .foregroundColor(.white)
//                                        .frame(maxWidth: .infinity)
//                                        .frame(height: 30)
//                                         //.frame(width: 70, height: 30)
//                                        .background(Color.blue)
//                                        .cornerRadius(6)
//                                        .padding(.horizontal, 8)
//                                }
//                                //.frame(maxWidth: .infinity, alignment: .trailing)
//                            }
//                            .padding(.horizontal)
//                            .padding(.vertical, 8)
//                            Divider()
//                        }
//                    }
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//}

struct MissedApprovalSectionCard: View {
    let title: String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 8)

    }
}

#Preview {
    MissedPunchApproval()
}

