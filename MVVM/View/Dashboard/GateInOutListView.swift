//
//  dummyView.swift
//  GoDairy
//
//  Created by San eforce on 10/10/25.

import SwiftUI

struct GateInOutListView: View {
    
    @StateObject var gateInOutListVM = GateIn_OutViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                GateInOutListCard(GateInOutVM: gateInOutListVM)
            }
            .onAppear {
                Task {
                    await gateInOutListVM.fetchgateInOutListData()
                }
            }
        }
    }
}

struct GateInOutListCard: View {
    @ObservedObject var GateInOutVM: GateIn_OutViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(GateInOutVM.gateInOutListData) { record in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(record.HQLoc ?? "-")
                            Spacer()
                            Text(record.time ?? "-")
                        }
                        .regularTextStyle(size: 14, foreground: .black, fontWeight: .regular)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("IN TIME")
                                    .regularTextStyle(size: 14, foreground: .black, fontWeight: .regular)
                                Text(record.Itime ?? "-")
                                    .regularTextStyle(size: 15, foreground: .black, fontWeight: .bold)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 10) {
                                Text("OUT TIME")
                                    .regularTextStyle(size: 14, foreground: .black, fontWeight: .regular)
                                Text(record.Otime ?? "-")
                                    .regularTextStyle(size: 15, foreground: .black, fontWeight: .bold)
                            }
                        }
                        //.padding(.horizontal)
                        
                        HStack(alignment: .top) {
                            Text("IN GEO")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                            Text(record.latLng ?? "-")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .multilineTextAlignment(.trailing)
                        }
                        .regularTextStyle(size: 14, foreground: .black, fontWeight: .regular)

                        HStack(alignment: .top) {
                            Text("OUT GEO")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                            Text(record.OlatLng ?? "-")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .multilineTextAlignment(.trailing)
                        }
                        .regularTextStyle(size: 14, foreground: .black, fontWeight: .regular)
                        

                        
                        Divider()
                            .overlay(Color.gray.opacity(0.3))
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                    //.background(Color.white)
                    //.cornerRadius(8)
                    //.shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
//                    .onTapGesture {
//                        print("Tapped record: \(record.id)")
//                    }
                }
            }
            .padding(.horizontal)
        }

    }
}


#Preview {
    GateInOutListView()
}
