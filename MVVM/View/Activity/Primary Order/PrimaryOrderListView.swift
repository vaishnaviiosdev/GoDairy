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

//struct PrimaryOrderList: View {
//    @ObservedObject var primaryOrderVM: PrimaryorderViewModel
//    
//    var body: some View {
//        ScrollView {
//            LazyVStack(spacing: 0) {
//                ForEach(primaryOrderVM.primaryOrderDataResponse.indices, id: \.self) { index in
//                    CustomerRow(
//                        customer: primaryOrderVM.primaryOrderDataResponse[index],
//                        isFirst: index == 0
//                    )
//                    
//                    if index != primaryOrderVM.primaryOrderDataResponse.count - 1 {
//                        Divider()
//                            .padding(.horizontal)
//                    }
//                }
//            }
//            .padding(.top, 10)
//        }
//    }
//}

struct PrimaryOrderList: View {
    @ObservedObject var primaryOrderVM: PrimaryorderViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(primaryOrderVM.primaryOrderDataResponse) { customer in
                    NavigationLink(destination: PrimaryOrderHistoryView(customer: customer)) {
                        CustomerRow(
                            customer: customer,
                            isFirst: primaryOrderVM.primaryOrderDataResponse.first?.id == customer.id
                        )
                    }
                    
                    if customer.id != primaryOrderVM.primaryOrderDataResponse.last?.id {
                        Divider()
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.top, 10)
        }
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
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color.blue.opacity(0.9), Color.blue.opacity(0.7)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 55, height: 55)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)

                Text(initial)
                    .font(.title2)
                    .regularTextStyle(foreground: .white, fontWeight: .heavy)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(customer.name ?? "")
                    .regularTextStyle(size: 16, foreground: .black, fontWeight: .medium)

                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack {
                            Text("Outstanding:")
                                .regularTextStyle(size: 14, foreground: .gray, fontWeight: .semibold)
                            Text(String(format: "₹ %.2f", customer.Out_stand ?? 0))
                                .regularTextStyle(size: 14, foreground: .gray, fontWeight: .semibold)

                            RefreshButton {
                                print("The Refresh Button is Tapped")
                            }
                        }

                        HStack {
                            Text("OverDue:")
                                .regularTextStyle(size: 14, foreground: .gray, fontWeight: .semibold)
                            Text(String(format: "₹ %.2f", customer.overDue ?? 0))
                                .regularTextStyle(size: 14, foreground: .gray, fontWeight: .semibold)
                        }

                        Text(customer.Mobile ?? "------")
                            .regularTextStyle(size: 14, foreground: .gray, fontWeight: .regular)
                            .padding(.top, 2)
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .background( //tl: topleft; tr: topright; bl: bottomleft; bottomright: bottomright.
            isFirst ?
            RoundedCorners(color: .white, tl: 40, tr: 40, bl: 0, br: 0) :
            RoundedCorners(color: .white, tl: 0, tr: 0, bl: 0, br: 0)
        )
    }
}

#Preview {
    PrimaryOrderListView()
}
