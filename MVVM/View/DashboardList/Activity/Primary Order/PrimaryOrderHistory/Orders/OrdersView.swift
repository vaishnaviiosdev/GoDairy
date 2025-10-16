//
//  OrdersView.swift
//  GoDairy
//
//  Created by San eforce on 13/10/25.
//

import SwiftUI

let SubCategoryList: [String] = ["FRESH MILK", "CURD", "BUTTER WITH LONG 123", "LASSI"]
let productList: [String] = ["FULL CREAM MILK", "STANDARD MILK", "TONED MILK"]

struct OrdersView: View {
    let customer: primaryOrderData
    @StateObject var ordersDataVM = ordersViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColour
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    homeBarTop(frameSize: 50, customer: customer)
                        //.padding(.top, 4)

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            CustomerSection(customer: customer)
                            DependentScrollViewUI(customer: customer, ordersDataViewModel: ordersDataVM)
                            ProductDetailView()
                            proceedBtnView()
                                .padding(.horizontal, 6)
                                .padding(.bottom, 10)
                        }
                    }
                }
            }
            .navigationTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await ordersDataVM.PostCategoryList(id: customer.id)
                }
            }
        }
    }
}

struct homeBarTop: View {
    @State private var currentTime: String = ""
    let fixedTime = "13:00:00"
    var frameSize: CGFloat = 40
    var customer: primaryOrderData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading) {
                    Text("GoDiary")
                        .regularTextStyle(size: 15, foreground: .white, fontWeight: .heavy)
                        
                    Text("Version : \(appVersion ?? "")")
                        .regularTextStyle(size: 11, foreground: .white, fontWeight: .heavy)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
                Spacer()
                
                Text("VIEW HISTORY")
                    .regularTextStyle(size: 15, foreground: .white, fontWeight: .semibold)

                NavigationLink(destination: DashboardView()) {
                    Image(systemName: "house.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding(.trailing, 5)
                }
            }
            .frame(height: frameSize)
            .background(Color.appPrimary)
            
            HStack {
                Text("PRIMARY ORDER")
                    .regularTextStyle(size: 18, foreground: .white, fontWeight: .heavy)
                    .padding(.leading, 2)
                
                Text("Milk")
                    .regularTextStyle(size: 13, foreground: .white, fontWeight: .heavy)
                
                Spacer()
                
                Text("\(currentTime)  /  \(fixedTime)")
                    .regularTextStyle(size: 15, foreground: .white, fontWeight: .heavy)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 30)
            .padding(.horizontal, 8)
            .background(Color.appPrimary)
        }
        .onAppear {
            updateTime()
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                updateTime()
            }
        }
    }
    
    private func updateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss" // 24-hour format
        currentTime = formatter.string(from: Date())
    }
}

struct CustomerSection: View {
    var customer: primaryOrderData
    var body: some View {
        VStack {
            CustomerSection1(customer: customer)
            CustomerSection2(customer: customer)
            CustomerSection3(customer: customer)
        }
        .background(Color.white)
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 5)
        .padding(.vertical, 5)
    }
}

struct CustomerSection1: View {
    var customer: primaryOrderData
    var body: some View {
        HStack {
            CustomDropdownButton(title: customer.name ?? "---", fontSize: 16, fontWeight: .semibold) {
                print("Tapped dropdown")
            }
            Spacer()
            Button(action: {}) {
                HStack(spacing: 5) {
                    Image("camera_Img")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.leading, 10)
                    Text("Event Capture")
                        .regularTextStyle(size: 13, foreground: .white, fontWeight: .heavy)
                        .font(.subheadline)
                        .padding(.trailing, 10)
                        .padding(.vertical, 10)
                }
                .background(Color.appPrimary)
            }
            .cornerRadius(8)
        }
        .padding(.horizontal, 5)
        .padding(.top)
    }
}

struct CustomerSection2: View {
    var customer: primaryOrderData
    var body: some View {
        HStack(spacing: 5) {
            VStack(alignment: .leading, spacing: 5) {
                Text(customer.ERP_Code ?? "0")
                    .regularTextStyle(size: 12, foreground: .black, fontWeight: .medium)
                Text(Date().formattedAsDDMMYYYY())
                    .regularTextStyle(size: 12, foreground: .black, fontWeight: .medium)
            }
            
            Button(action: {
                print("Repeat Order is Tapped")
            }) {
                Text("REPEAT ORDER")
                    //.font(.subheadline)
                    .regularTextStyle(size: 13, foreground: .white, fontWeight: .bold)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.appPrimary,
                                Color.gradientColour2
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(10)
            }
            Spacer()
            Text("₹9,185.10")
                .regularTextStyle(size: 17, foreground: .appPrimary, fontWeight: .bold)
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
    }
}

struct CustomerSection3: View {
    var customer: primaryOrderData
    var body: some View {
        HStack(spacing: 0) {
            Text("Outstanding: \(String(format: "₹ %.2f", customer.Out_stand ?? 0))")
            //String(format: "₹ %.2f", customer.Out_stand ?? 0)
                .regularTextStyle(size: 14, foreground: .black, fontWeight: .regular)
            Spacer()
            Text("Order Limit Value")
                .regularTextStyle(size: 14, foreground: .black, fontWeight: .regular)
            RefreshButton(action:  {
                print("The Refresh Button is Tapped")
            }, foregroundColour: .black, frameSize: 15)
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 10)
    }
}

struct DependentScrollViewUI: View {
    var customer: primaryOrderData
    @ObservedObject var ordersDataViewModel: ordersViewModel

    @State private var selectedCategory: String = "Milk"
    @State private var selectedSubCategory: String = "FRESH MILK"
    @State private var selectedProduct: String = "FULL CREAM MILK"

    let categoryList: [String] = ["Milk", "UHT Milk", "Butter and Yogurt", "Ice Cream"]
    let subCategoryList: [String] = ["FRESH MILK", "CURD", "BUTTER WITH LONG 123", "LASSI"]
    let productList: [String] = ["FULL CREAM MILK", "STANDARD MILK", "TONED MILK"]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            categoryScrollView
            subCategoryScrollView
            Divider()
                .background(Color.gray)
                .padding(.horizontal, 8)
            productScrollView
        }
        .padding(.top, 8)
    }
}

// MARK: - Category Scroll
private extension DependentScrollViewUI {
    var categoryScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(ordersDataViewModel.categoryData) { category in
                    categoryItem(category.name)
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private func categoryItem(_ category: String) -> some View {
        let isSelected = selectedCategory == category

        Text(category)
            .regularTextStyle(
                size: 12,
                foreground: isSelected ? .blue : .gray,
                fontWeight: .bold
            )
            .borderedTab(isSelected: isSelected, leading: 0, cornerR: 10)
            .onTapGesture { selectedCategory = category }
    }
}

// MARK: - Subcategory Scroll
private extension DependentScrollViewUI {
    var subCategoryScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(subCategoryList, id: \.self) { sub in
                    subCategoryItem(sub)
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private func subCategoryItem(_ sub: String) -> some View {
        let isSelected = selectedSubCategory == sub

        Text(sub)
            .regularTextStyle(
                size: 12,
                foreground: isSelected ? .blue : .gray,
                fontWeight: .bold
            )
            .borderedTab(isSelected: isSelected, leading: 0, cornerR: 10)
            .onTapGesture { selectedSubCategory = sub }
    }
}

// MARK: - Product Scroll
private extension DependentScrollViewUI {
    var productScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(productList, id: \.self) { product in
                    productItem(product)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }

    @ViewBuilder
    private func productItem(_ product: String) -> some View {
        let isSelected = selectedProduct == product

        Text(product)
            .regularTextStyle(
                size: 12,
                foreground: isSelected ? .blue : .gray,
                fontWeight: .bold
            )
            .borderedTab(isSelected: isSelected, leading: 25, vertical: 13, cornerR: 10)
            .onTapGesture { selectedProduct = product }
    }
}


//struct DependentScrollViewUI: View {
//    var customer: primaryOrderData
//    @ObservedObject var ordersDataViewModel: ordersViewModel
//    @State private var selectedCategory: String = "Milk"
//    @State private var selectedSubCategory: String = "FRESH MILK"
//    @State private var selectedProduct: String = "FULL CREAM MILK"
//
//    let categoryList: [String] = ["Milk", "UHT Milk", "Butter and Yogurt", "Ice Cream"]
//    let subCategoryList: [String] = ["FRESH MILK", "CURD", "BUTTER WITH LONG 123", "LASSI"]
//    let productList: [String] = ["FULL CREAM MILK", "STANDARD MILK", "TONED MILK"]
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            categoryScrollView
//            subCategoryScrollView
//            Divider()
//                .background(.gray)
//                .padding(.horizontal, 8)
//            productScrollView
//        }
//        .padding(.top, 8)
//    }
//
//    private var categoryScrollView: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 10) {
//                ForEach(ordersDataViewModel.categoryData) { category in
//                    Text(category)
//                        .regularTextStyle(size: 12, foreground: selectedCategory == category ? .blue : .gray, fontWeight: .bold)
//                        .borderedTab(isSelected: selectedCategory == category, leading: 0, cornerR: 10)
//                        .onTapGesture {
//                            selectedCategory = category
//                        }
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//    
//    private var subCategoryScrollView: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 10) {
//                ForEach(subCategoryList, id: \.self) { sub in
//                    Text(sub)
//                        .regularTextStyle(size: 12, foreground: selectedSubCategory == sub ? .blue : .gray, fontWeight: .bold)
//                        .borderedTab(isSelected: selectedSubCategory == sub, leading: 0, cornerR: 10)
//                        .onTapGesture {
//                            selectedSubCategory = sub
//                        }
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//
//    private var productScrollView: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 10) {
//                ForEach(productList, id: \.self) { product in
//                    Text(product)
//                        .regularTextStyle(size: 12, foreground: selectedProduct == product ? .blue : .gray, fontWeight: .bold)
//                        .borderedTab(isSelected: selectedProduct == product, leading: 25, vertical: 13, cornerR: 10)
//                        .onTapGesture {
//                            selectedProduct = product
//                        }
//                }
//            }
//            .padding(.horizontal)
//            .padding(.bottom)
//        }
//    }
//}

struct ProductDetailView: View {
    var body: some View {
        
        VStack(spacing: 0) {
            VStack {
                HStack {
                    Text("FULL CREAM MILK ( 1 )")
                        .regularTextStyle(size: 19, foreground: .black, fontWeight: .semibold)
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                }
                .padding(.leading, 9)
                .padding(.vertical, 13)
            }
            .cardStyle(cornerRadius: 5)
            .padding(.horizontal, 8)
            
            VStack {
                productListView()
            }
            //.padding()
            .cardStyle(cornerRadius: 4)
            .padding(.horizontal, 8)
        }
    }
}

struct productListView: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("FCMHOMOGENIZE")
                    .regularTextStyle(size: 16, foreground: .black, fontWeight: .semibold)
                Text("DMILKSACHET500")
                    .regularTextStyle(size: 16, foreground: .black, fontWeight: .semibold)
                Text("ML-FARM-1104")
                    .regularTextStyle(size: 16, foreground: .black, fontWeight: .semibold)
                Text("10375")
                    .regularTextStyle(size: 12, foreground: .black, fontWeight: .medium)
                
                PriceDetailView()
                QtyView()
                
                Text("Order Qty Multiple of : 1")
                    .regularTextStyle(size: 11, foreground: .black, fontWeight: .regular)
                
                productSubDetails()
                
                productAmountDetails()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 9)
            .padding(.vertical, 13)
        }
        .cardStyle(cornerRadius: 4)
        .padding(.horizontal, 8)
        .padding(.vertical, 8)

    }
}

struct PriceDetailView: View {
    var body: some View {
        HStack(spacing: 15) {
            Text("MRP")
                .regularTextStyle(size: 13, foreground: .black, fontWeight: .regular)
            Text("₹ 200.0")
                .regularTextStyle(size: 13, foreground: .black, fontWeight: .semibold)
            Text("Price")
                .regularTextStyle(size: 13, foreground: .black, fontWeight: .regular)
            Text("₹ 240.0")
                .regularTextStyle(size: 13, foreground: .black, fontWeight: .semibold)
        }
    }
}

struct QtyView: View {
    var body: some View {
        HStack(spacing: 5) {
            Text("Qty :")
                .regularTextStyle(size: 13, foreground: .black, fontWeight: .regular)
            
            HStack {
                Button(action: {
                    print("Minus Button is tapped")
                }) {
                    Image(systemName: "minus")
                .regularTextStyle(size: 12, foreground: .red, fontWeight: .bold)
                }
                
                Spacer().frame(width: 20)
                
                Text("0")
                    .regularTextStyle(size: 15, foreground: .gray, fontWeight: .semibold)
                
                Spacer().frame(width: 20)
                
                Button(action: {
                    print("Plus Button is tapped")
                }) {
                    Image(systemName: "plus")
                        .regularTextStyle(size: 12, foreground: .green, fontWeight: .bold)
                }
            }
            .frame(height: 15)
            .borderedTab(isSelected: false, leading: 0, cornerR: 5)
            
            HStack {
                Text("kilogram")
                    .regularTextStyle(size: 12, foreground: .gray, fontWeight: .bold)
            }
            .frame(height: 15)
            .borderedTab(isSelected: false, leading: 0, cornerR: 5)
            
            Spacer()
        }
    }
}

struct productSubDetails: View {
    var body: some View {
        VStack {
            HStack {
                Text("Crate-Green")
                    .regularTextStyle(size: 13)
                Spacer()
                Text("0")
                    .regularTextStyle(size: 13, fontWeight: .medium)
            }
            HStack {
                Text("kilogram")
                    .regularTextStyle(size: 13)
                Spacer()
                Text("0")
                    .regularTextStyle(size: 13, fontWeight: .medium)
            }
            HStack {
                Text("Crate-Blue")
                    .regularTextStyle(size: 13)
                Spacer()
                Text("0")
                    .regularTextStyle(size: 13, fontWeight: .medium)
            }
        }
        .padding(.trailing, 8)
        .padding(.top, 8)
    }
}

struct productAmountDetails: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                HStack {
                    Text("Free :")
                        .regularTextStyle(size: 13)
                    
                    Text("0")
                        .regularTextStyle(size: 13, foreground: .acceptBtn, fontWeight: .bold)
                }
                
                Spacer()
                
                HStack {
                    Text("Discount :")
                        .regularTextStyle(size: 13)
                    
                    Text("₹ 0.00")
                        .regularTextStyle(size: 13, foreground: .red, fontWeight: .bold)
                }
                
            }
            HStack {
                Text("kilogram")
                    .regularTextStyle(size: 13)
                Spacer()
                Text("₹ 0.00")
                    .regularTextStyle(size: 13, fontWeight: .medium)
            }
            HStack {
                Text("Crate-Blue")
                    .regularTextStyle(size: 13)
                Spacer()
                Text("₹ 0.00")
                    .regularTextStyle(size: 13, fontWeight: .medium)
            }
            
            Divider()
                .background(.gray)
                .padding(.horizontal, 8)
            
            HStack {
                Text("Total Qty : 0")
                    .regularTextStyle(size: 13)
                Spacer()
                Text("₹ 0.00")
                    .regularTextStyle(size: 17, fontWeight: .bold)
            }
        }
        .padding(.trailing, 8)
        .padding(.top, 8)
    }
}

struct proceedBtnView: View {
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "bag.fill")
                Text("₹ 0.00  Items: 0  Qty: 0")
                    .font(.system(size: 16, weight: .heavy))
            }
            .foregroundColor(.white)
            
            Spacer()
            
            Text("PROCEED")
                .font(.system(size: 16, weight: .heavy))
                .foregroundColor(.white)
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.appPrimary,
                    Color.gradientColour2
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(10)
    }
}

#Preview {
    OrdersView(customer: primaryOrderData(
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
    ))
}
