//
//  GeoTaggingView.swift
//  GoDairy
//
//  Created by Naga Prasath on 30/09/25.
//

import SwiftUI

struct GeoTaggingView: View {
    
    @StateObject  var geoTaggingVM = GeoTaggingViewModel()
    
    var body: some View {
        NavigationStack {
            VStack{
                homeTitleBar()
                
                ScrollView{
                    LazyVStack() {
                        if let items = geoTaggingVM.geoTaggingModelData?.response {
                                ForEach(items) { item in
                                    GeoTaggingRow(item: item)
                                }
                        }
                        
                    }
                }
                
                Spacer()
            }
            
            
            .task {
                await geoTaggingVM.fetchGeoTaggingData()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


struct homeTitleBar: View {
    var frameSize: CGFloat = 40
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            Button(action:{
                dismiss()
            }){
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .padding() // optional padding from edge
            }
            Spacer()

            NavigationLink(destination: DashboardView()) {
                Image(systemName: "house.fill")
                    .foregroundColor(.white)
                    .padding(.trailing, 16)
            }
        }
        .frame(height: frameSize)
        .background(Color.appPrimary)
    }
}

struct GeoTaggingRow: View {
    let item: GeoTaggingModel

    var body: some View {
        VStack{
            HStack {
                TextColumn(text: "Field ForceName", alignment: .leading)
                TextColumn(text: "Field ForceName", alignment: .leading)
                
            }
            
            HStack {
                TextColumn(text: "Field ForceName", alignment: .leading)
                TextColumn(text: "Field ForceName", alignment: .leading)
                
            }
        }
        Spacer()
    }
}

#Preview {
    GeoTaggingView()
}
