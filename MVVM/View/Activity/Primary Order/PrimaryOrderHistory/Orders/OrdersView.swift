//
//  OrdersView.swift
//  GoDairy
//
//  Created by San eforce on 13/10/25.
//

import SwiftUI

let CategoryList: [String] = ["Milk", "UHT Milk", "Butter and Yogurt", "Ice Cream"]
let SubCategoryList: [String] = ["FRESH MILK", "CURD", "BUTTER WITH LONG 123", "LASSI"]
let productList: [String] = ["FULL CREAM MILK", "STANDARD MILK", "TONED MILK"]

struct OrdersView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColour.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    homeBarTop(frameSize: 50)
                    
                    VStack {
                        CustomerSection()
                        DependentScrollViewUI()
                        ProductDetailView()
                    }
                }
            }
            .navigationTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct homeBarTop: View {
    var frameSize: CGFloat = 40
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading) {
                    Text("GoDiary")
                        .regularTextStyle(size: 15, foreground: .white, fontWeight: .heavy)
                        
                    Text("Version v3.4")
                        .regularTextStyle(size: 11, foreground: .white, fontWeight: .heavy)
                }
                .padding(.vertical, 5)
                Spacer()
                
                Text("VIEW HISTORY")
                    .regularTextStyle(size: 15, foreground: .white, fontWeight: .semibold)

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
            
            HStack {
                Text("PRIMARY ORDER")
                    .regularTextStyle(size: 18, foreground: .white, fontWeight: .heavy)
                    .padding(.leading, 2)
                
                Text("Milk")
                    .regularTextStyle(size: 13, foreground: .white, fontWeight: .heavy)
                
                Spacer()
                
                Text("17:30:13  /  13:00:00 ")
                    .regularTextStyle(size: 15, foreground: .white, fontWeight: .heavy)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 30)
            .background(Color.appPrimary)
        }
    }
}

struct CustomerSection: View {
    var body: some View {
        VStack {
            CustomerSection1()
            CustomerSection2()
            CustomerSection3()
        }
        .background(Color.white)
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 5)
        .padding(.vertical, 5)
    }
}

struct CustomerSection1: View {
    var body: some View {
        HStack {
            CustomDropdownButton(title: "SAI PRASANNA(105005)", fontSize: 16, fontWeight: .semibold) {
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
                        .regularTextStyle(size: 15, foreground: .white, fontWeight: .bold)
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
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                Text("105005")
                    .regularTextStyle(size: 14, foreground: .black, fontWeight: .bold)
                Text("14-Oct-2025")
                    .regularTextStyle(size: 14, foreground: .black, fontWeight: .bold)
            }
            
            Button(action: {
                print("Repeat Order is Tapped")
            }) {
                Text("REPEAT ORDER")
                    .font(.subheadline)
                    .regularTextStyle(foreground: .white, fontWeight: .semibold)
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
                    .cornerRadius(15)
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
    var body: some View {
        HStack(spacing: 0) {
            Text("Outstanding: ₹ 0.00")
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
                .background(.gray)
                .padding(.horizontal, 8)
            productScrollView
        }
        .padding(.top, 8)
    }

    private var categoryScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categoryList, id: \.self) { category in
                    Text(category)
                        .regularTextStyle(size: 12, foreground: selectedCategory == category ? .blue : .gray, fontWeight: .bold)
                        .borderedTab(isSelected: selectedCategory == category, leading: 0, cornerR: 10)
                        .onTapGesture {
                            selectedCategory = category
                        }
                }
            }
            .padding(.horizontal)
        }
    }

    private var subCategoryScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(subCategoryList, id: \.self) { sub in
                    Text(sub)
                        .regularTextStyle(size: 12, foreground: selectedSubCategory == sub ? .blue : .gray, fontWeight: .bold)
                        .borderedTab(isSelected: selectedSubCategory == sub, leading: 0, cornerR: 10)
                        .onTapGesture {
                            selectedSubCategory = sub
                        }
                }
            }
            .padding(.horizontal)
        }
    }

    private var productScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(productList, id: \.self) { product in
                    Text(product)
                        .regularTextStyle(size: 12, foreground: selectedProduct == product ? .blue : .gray, fontWeight: .bold)
                        .borderedTab(isSelected: selectedProduct == product, leading: 25, vertical: 13, cornerR: 10)
                        .onTapGesture {
                            selectedProduct = product
                        }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}

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
        }
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

#Preview {
    OrdersView()
}
