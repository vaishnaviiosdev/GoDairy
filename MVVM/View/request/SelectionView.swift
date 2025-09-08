

import SwiftUI

// MARK: - SelectionView (Popup)
struct SelectionView: View {
    @Binding var isPresented: Bool
    @State private var searchText = ""
    
    let items: [String]
    let title: String                
    let onItemSelected: (String) -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(alignment: .leading, spacing: 0) {
                selectedItem(title: title)
                
                SearchBarView(searchText: $searchText)
                
                SelectableListView(
                    isPresented: $isPresented,
                    searchText: $searchText,
                    items: items,
                    onItemSelected: onItemSelected
                )
                .frame(maxHeight: 300)
                .padding(.top, 8)
                
                closeBtnView(isPresented: $isPresented)
            }
            .background(Color.white)
            .frame(maxWidth: 350)
        }
    }
}

// MARK: - Title View
struct selectedItem: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.system(size: 14)).fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 30)
            .padding(.leading, 8)
            .background(Color.appPrimary)
            .foregroundColor(.white)
    }
}

// MARK: - Search Bar View
struct SearchBarView: View {
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

// MARK: - Selectable List View
struct SelectableListView: View {
    @Binding var isPresented: Bool
    @Binding var searchText: String
    let items: [String]
    let onItemSelected: (String) -> Void
    
    var filteredItems: [String] {
        if searchText.isEmpty {
            return items
        }
        else {
            return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(filteredItems, id: \.self) { item in
                    Button(action: {
                        onItemSelected(item)
                        isPresented = false
                    }) {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(colorData.shared.app_primary1)
                                .frame(width: 40, height: 40)
                                .overlay(Text(String(item.prefix(1))).foregroundColor(.white))
                            Text(item)
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

// MARK: - Close Button
struct closeBtnView: View {
    @Binding var isPresented: Bool
    var body: some View {
        HStack {
            Spacer()
            Button(action: { isPresented = false }) {
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

// MARK: - Preview
struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView(
            isPresented: .constant(true),
            items: ["Casual Leave", "Paid Leave", "Loss of Pay", "Sick Leave"],
            title: "Select Leave Type"
        ) { selected in
            print("Selected: \(selected)")
        }
    }
}



