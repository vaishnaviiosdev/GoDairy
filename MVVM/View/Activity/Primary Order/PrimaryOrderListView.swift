//
//  PrimaryOrderListView.swift
//  GoDairy
//
//  Created by San eforce on 08/10/25.
//

import SwiftUI

struct PrimaryOrderListView: View {
    
    @StateObject var  primaryorderVM = PrimaryorderViewModel()
    
    var body: some View {
        ZStack {
            Color.appPrimaryLight
               
            VStack(alignment: .leading, spacing: 0) {
                TopView()

                Text("Primary list")
                    .font(.footnote)
                    .regularTextStyle(foreground: .black, fontWeight: .semibold)
                    .padding(.horizontal)

                ScrollView {
                    PrimaryOrderList(primaryOrderVM: primaryorderVM)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                await primaryorderVM.fetchPrimaryOrderData()
            }
        }
    }
}

struct TopView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Search")
                    .font(.title2)
//                    .foregroundColor(.black)
//                    .fontWeight(.medium)
                    .regularTextStyle(foreground: .black, fontWeight: .medium)

                Spacer()

                Image("loupe")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .padding()
        }
    }
}

//struct primaryOrderList: View {
//    var primaryOrdervm: PrimaryorderViewModel
//    var body: some View {
//        LazyVStack(spacing: 0) {
//            ForEach(sampleCustomers.indices, id: \.self) { index in
//                CustomerRow(
//                    customer: sampleCustomers[index],
//                    isFirst: index == 0
//                )
//
//                if index != sampleCustomers.count - 1 {
//                    Divider()
//                        .padding(.horizontal)
//                }
//            }
//        }
//        .padding(.top, 10)
//    }
//}

struct PrimaryOrderList: View {
    @ObservedObject var primaryOrderVM: PrimaryorderViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(primaryOrderVM.primaryOrderDataResponse.indices, id: \.self) { index in
                    CustomerRow(
                        customer: primaryOrderVM.primaryOrderDataResponse[index],
                        isFirst: index == 0 // top corners only for first card
                    )
                    
                    if index != primaryOrderVM.primaryOrderDataResponse.count - 1 {
                        Divider()
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.top, 10)
        }
    }
}


// ✅ Customer model
struct Customer: Identifiable {
    let id: String?
    let name: String?
    let outstanding: Double?
    let overdue: Double?
    let phone: String?

    var displayName: String {
        "\(name ?? "SAI PRASANNA")(\(id ?? "10085"))"
    }

    var initial: String {
        String(name?.prefix(1) ?? "S").uppercased()
    }
}

// ✅ CustomerRow view
struct CustomerRow: View {
    let customer: primaryOrderData
    let isFirst: Bool  // NEW
    
    var initial: String {
        String(customer.name?.prefix(1) ?? "").uppercased()
    }

    var body: some View {
        HStack(alignment: .top, spacing: 5) {
            // Initial Circle
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color.blue.opacity(0.9), Color.blue.opacity(0.7)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 55, height: 55)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)

                Text(initial)
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.heavy)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(customer.name ?? "")
                    //.font(.system(size: 16, weight: .medium))
                    .regularTextStyle(size: 16, fontWeight: .medium)
                    .foregroundColor(.black)

                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack {
                            Text("Outstanding:")
//                                .foregroundColor(.gray)
//                                .font(.system(size: 14))
//                                .fontWeight(.semibold)
                                .regularTextStyle(size: 14, foreground: .gray, fontWeight: .semibold)
                            Text(String(format: "₹ %.2f", customer.Out_stand ?? 0))
//                                .font(.system(size: 14))
//                                .foregroundColor(.gray)
//                                .fontWeight(.semibold)
                                .regularTextStyle(size: 14, foreground: .gray, fontWeight: .semibold)

                            RefreshButton {
                                print("The Refresh Button is Tapped")
                            }
                        }

                        HStack {
                            Text("OverDue:")
//                                .foregroundColor(.gray)
//                                .font(.system(size: 14))
//                                .fontWeight(.semibold)
                                .regularTextStyle(size: 14, foreground: .gray, fontWeight: .semibold)
                            Text(String(format: "₹ %.2f", customer.overDue ?? 0))
//                                .font(.system(size: 14))
//                                .foregroundColor(.gray)
//                                .fontWeight(.semibold)
                                .regularTextStyle(size: 14, foreground: .gray, fontWeight: .semibold)
                        }

                        Text(customer.Mobile ?? "------")
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                            .fontWeight(.regular)
                            .regularTextStyle(size: 14, foreground: .gray, fontWeight: .regular)
                            .padding(.top, 2)
                    }
                    Spacer()
                }
            }
            //.padding(.vertical, 10)
        }
        .padding()
        .background(
            // ✅ RoundedCorners only for the first item
            isFirst ?
            RoundedCorners(color: .white, tl: 40, tr: 40, bl: 0, br: 0) :
            RoundedCorners(color: .white, tl: 0, tr: 0, bl: 0, br: 0)
        )
    }
}


// ✅ Sample data for preview/testing
let sampleCustomers: [Customer] = [
    Customer(id: "105005", name: "SAI PRASANNA", outstanding: 0.0, overdue: 0.0, phone: "9866607280"),
    Customer(id: "105006", name: "R.NAIDU", outstanding: 24.0, overdue: 0.0, phone: "7893632949"),
    Customer(id: "105007", name: "VENKATASWARA", outstanding: 0.0, overdue: 0.0, phone: "9866493102"),
    Customer(id: "105011", name: "AQSA MILK(ALAM KHAN)", outstanding: 0.0, overdue: 0.0, phone: "9989170065"),
    Customer(id: "105013", name: "ICB", outstanding: 0.0, overdue: 0.0, phone: "9000870092"),
    Customer(id: "105076", name: "CHANDRA", outstanding: 0.0, overdue: 0.0, phone: "9980117012")
]


#Preview {
    PrimaryOrderListView()
}
