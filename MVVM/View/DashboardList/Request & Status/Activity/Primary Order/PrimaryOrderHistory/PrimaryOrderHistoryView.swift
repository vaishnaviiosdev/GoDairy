//
//  PrimaryOrderHistoryView.swift
//  GoDairy
//
//  Created by San eforce on 08/10/25.
//

import SwiftUI

struct PrimaryOrderHistoryView: View {
    let customer: primaryOrderData
    @State private var selectedEmployee = "SAI PRASANNA(105005)"
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var searchText = ""
    @State private var selectedFilter = "All"

    let employees = ["SAI PRASANNA(105005)", "JOHN(105002)", "ANITA(105010)"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColour
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    homeBar(frameSize: 40)
                        .padding(.top, 4)
                    
                    titleCard(title: "PRIMARY ORDER HISTORY", frameHeight: 40, fontSize: 18)

                    VStack(spacing: 8) {
                        
                        CustomDropdownButton(title: customer.name ?? "") {
                            print("Tapped dropdown")
                        }

                        HStack(spacing: 10) {
                            CustomDatePicker(selectedDate: $startDate, cornerRadius: 5, frameHeight: 45, textForegroundColor: .gray, textFontWeight: .medium)
                            CustomDatePicker(selectedDate: $endDate, cornerRadius: 5, frameHeight: 45, textForegroundColor: .gray, textFontWeight: .medium)
                        }
                        .padding(.horizontal, 8)

                        searchBarView(searchText: $searchText)
                            .padding(.horizontal, 12)
                        
                        allView()
                            .padding(.horizontal, 8)
                        
                        tableHeader()
                            .frame(height: 45)
                            .background(Color.appPrimary)
                            .padding(.top)

                        ScrollView {
                            invoiceListView()
                                .padding(.horizontal, 8)
                        }

                        Spacer()
                        
                        totalAmountView()
                            .padding(.horizontal, 8)

                        bottomButtonView(customer: customer)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct titleHeadingCard: View {
    let frameHeight: CGFloat
    var body: some View {
        Text("PRIMARY ORDER HISTORY")
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .frame(height: frameHeight)
            .background(Color.appPrimary)
    }
}

//struct userNamewithID: View {
//    @Binding var selectedEmployee: String
//    let employees = ["SAI PRASANNA(105005)", "JOHN(105002)", "ANITA(105010)"]
//    var body: some View {
//        HStack(spacing: 8) {
//            Text(selectedEmployee)
//                .regularTextStyle(size: 14, foreground: .black, fontWeight: .medium)
//            Image(systemName: "arrowtriangle.down.fill")
//                .resizable()
//                .frame(width: 8, height: 6)
//                .regularTextStyle(size: 12, foreground: .black)
//            Spacer()
//        }
//        .padding(.vertical, 5)
//        .padding(.horizontal, 5)
//        .background(Color.white)
//        .cornerRadius(6)
//    }
//}

struct CustomDropdownButton: View {
    var title: String
    var icon: String = "arrowtriangle.down.fill"
    var background: Color = .white
    var foreground: Color = .black
    var fontSize: CGFloat = 14
    var fontWeight: Font.Weight = .medium
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .regularTextStyle(size: fontSize, foreground: foreground, fontWeight: fontWeight)
//                Image(systemName: icon)
//                    .resizable()
//                    .frame(width: 8, height: 6)
//                    .foregroundColor(foreground)
                Spacer()
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 5)
            .background(.clear)
            .cornerRadius(6)
            //.shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct searchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Custom placeholder
            if searchText.isEmpty {
                Text("Search here...")
                    .foregroundColor(.secondary) // 👈 Placeholder color
                    .padding(.leading, 14)
            }
            
            HStack {
                TextField("", text: $searchText)
                    .foregroundColor(.black)
                    .fontWeight(.regular)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 10)
        }
        .frame(height: 50)
        .cardStyle(backgroundColor: Color.appPrimaryMediumLight)
        .padding(.top, 8)
    }
}

struct allView: View {
    var body: some View {
        VStack() {
            Button(action: {
                print("All Button is Tapped")
            }) {
                Text("All")
                    //.font(.system(size: 13, weight: .bold))
                    .regularTextStyle(size: 13, foreground: .appPrimary1, fontWeight: .bold)
                    //.foregroundColor(.appPrimary1)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 9)
                            .stroke(Color.appPrimary3, lineWidth: 1)
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 10)
        .frame(height: 45)
        .cardStyle(cornerRadius: 5)
        .padding(.top, 8)
        .frame(maxWidth: .infinity)
    }
}

struct tableHeader: View {
    let headers = [("Invoice ID", Alignment.center),
                   ("Status", Alignment.center),
                   ("Value", Alignment.center)]

    var body: some View {
        HStack {
            ForEach(headers, id: \.0) { header in
                Text(header.0)
                    .frame(maxWidth: .infinity, alignment: header.1)
            }
        }
        .regularTextStyle(size: 15, foreground: .white, fontWeight: .bold)
        .padding(.horizontal, 8)
    }
}

struct invoiceListView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("SAI PRASANNA")
                        .regularTextStyle(size: 16, foreground: .black, fontWeight: .bold)
                    
                    Text("105005")
                        .regularTextStyle(size: 14, foreground: .black, fontWeight: .regular)
                    
                    HStack() {
                        Text("1050052526PO45")
                            .padding(.leading, 5)
                        Spacer()
                        Text("ORDER")
                        Spacer()
                        Text("960.00")
                    }
                    .regularTextStyle()
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Spacer()
                
                RefreshButton {
                    print("The Refresh Button is Tapped")
                }
                .padding()
            }
            
            HStack {
                Image("calendar 1")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.green)
                    .frame(width: 12, height: 12)
                    .padding(.leading, 12)
                
                Text("07/10/2025 11:42:51")
                    .regularTextStyle()
                
                Spacer()
                
                Text("Cutoff Time:13:00:00")
                    .regularTextStyle(size: 11)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

struct totalAmountView: View {
    var body: some View {
        VStack() {
            HStack {
                Text("Total")
                    //.font(.system(size: 20, weight: .semibold))
                    .regularTextStyle(size: 20, fontWeight: .semibold)
                
                Spacer()
                
                Text("960.00")
                    //.font(.system(size: 20, weight: .semibold))
                    .regularTextStyle(size: 20, fontWeight: .semibold)
                    .foregroundColor(Color.appSecondary2)
            }
        }
        .padding(.horizontal, 10)
        .frame(height: 45)
        .cardStyle(cornerRadius: 5)
        .frame(maxWidth: .infinity)
    }
}

//struct bottomButtonView: View {
//    let bottomButtons = ["Orders", "NO ORDER", "Activity", "Activity View", "Approval"]
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 10) {
//                ForEach(bottomButtons, id: \.self) { button in
//                    Button(action: {
//                        
//                    }) {
//                        Text(button)
//                            //.font(.system(size: 14, weight: .bold))
//                            .regularTextStyle(size: 14, fontWeight: .bold)
//                            .padding(.horizontal, 10)
//                            .padding(.vertical, 10)
//                            .background(Color.appPrimary)
//                            .foregroundColor(.white)
//                            .cornerRadius(11)
//                    }
//                }
//            }
//            .padding(.horizontal, 8)
//            .padding(.vertical, 8)
//        }
//    }
//}

struct bottomButtonView: View {
    let customer: primaryOrderData
    // Example button names
    let bottomButtons = ["Orders", "NO ORDER", "Activity", "Activity View", "Approval"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(bottomButtons, id: \.self) { button in
                    NavigationLink(destination: destinationView(for: button)) {
                        Text(button)
                            .regularTextStyle(size: 14, foreground: .white, fontWeight: .bold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 10)
                            .background(Color.appPrimary)
                            .cornerRadius(11)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
        }
    }
    
    // MARK: - Destination Selector
    @ViewBuilder
    private func destinationView(for button: String) -> some View {
        switch button {
        case "Orders":
            OrdersView(customer: customer)
        case "NO ORDER":
            OrdersView(customer: customer)
        case "Activity":
            OrdersView(customer: customer)
        case "Activity View":
            ActivityDashboardView()
        case "Approval":
            ApprovalMainView()
        default:
            Text("Coming Soon...")
        }
    }
}


#Preview {
    PrimaryOrderHistoryView(
        customer: primaryOrderData(
            id: "John Doe",
            StateCode: "1200",
            orderTaken: 300,
            name: "9876543210",
            Out_stand: nil,
            overDue: nil,
            Town_Code: nil,
            Town_Name: nil,
            Addr1: nil,
            Addr2: nil,
            City: nil,
            Pincode: nil,
            GSTN: nil,
            FSSAI: nil,
            lat: nil,
            long: nil,
            addrs: nil,
            Mobile: nil,
            Tcode: nil,
            Dis_Cat_Code: nil,
            ERP_Code: nil,
            DivERP: nil,
            Latlong: nil,
            CusSubGrpErp: nil,
            flag: nil,
            remarks: nil
        )
    )
}

