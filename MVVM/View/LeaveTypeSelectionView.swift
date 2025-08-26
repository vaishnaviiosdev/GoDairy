
import SwiftUI

struct LeaveTypeSelectionView: View {
    @Binding var isPresented: Bool
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            VStack(alignment: .leading, spacing: 0) {
                selectedItem()
                
                searchView(searchText: $searchText)
                
                leaveListView(isPresented: $isPresented, searchText: $searchText)
                    .frame(maxHeight: 300)
                    .padding(.top, 8)
                
                closeBtnView(isPresented: $isPresented)
            }
            .background(Color.white)
            .frame(maxWidth: 350)
        }
    }
}

struct selectedItem: View {
    var body: some View {
        Text("Select Item")
            .font(.system(size: 14)).fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 30)
            .padding(.leading, 8)
            .background(Color.appPrimary)
            .foregroundColor(.white)
    }
}

struct searchView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search", text: $searchText)
                .foregroundColor(.black)
                .disableAutocorrection(true)
                .autocapitalization(.none)
        }
        .padding(.horizontal, 10)
        .frame(height: 40)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.green, lineWidth: 1)
                .background(Color.white.cornerRadius(8))
        )
        .padding(.horizontal)
        .padding(.top)
    }
}

struct leaveListView: View {
    @Binding var isPresented: Bool
    @Binding var searchText: String
    
    let leaveTypes = ["Casual Leave", "Paid Leave", "Loss of Pay", "Sick Leave"]
    
    var filteredLeaveTypes: [String] {
        if searchText.isEmpty {
            return leaveTypes
        }
        else {
            return leaveTypes.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(filteredLeaveTypes, id: \.self) { type in
                    Button(action: {
                        print("\(type) selected")
                        isPresented = false
                    }) {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(colorData.shared.app_primary1)
                                .frame(width: 40, height: 40)
                                .overlay(Text(String(type.prefix(1))).foregroundColor(.white))
                            Text(type)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

struct closeBtnView: View {
    @Binding var isPresented: Bool
    var body: some View {
        HStack {
            Spacer() // Pushes the button to the right
            Button(action: {
                isPresented = false
            }) {
                Text("Close")
                    .frame(width: 100)
                    .padding()
                    .background(Color.appPrimary)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

struct LeaveTypeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LeaveTypeSelectionView(isPresented: .constant(true))
    }
}

