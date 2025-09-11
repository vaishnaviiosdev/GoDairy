

import SwiftUI

struct weeklyOffView: View {
    @State private var fromDate = Date()
    @State private var toDate = Date()
    @State private var showDaysSelection = false
    @StateObject var weekOffData = weeklyoffViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                
                ScrollView {
                    WeeklyOffCard(
                        title: "WEEKLY OFF",
                        fromDate: $fromDate,
                        toDate: $toDate,
                        onSubmit: {
                            showDaysSelection = true
                        }
                    )
                    
                    VStack {
                        if let items = weekOffData.weeklyOffData?.response {
                                ForEach(items) { item in
                                    WeekOffRow(item: item)
                                }
                        }
                        else {
                            Text("No week off data available")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    .padding(5)
                }
                .padding(5)
            }
            .overlay {
                if showDaysSelection {
                    DaysSelectionView(
                        isPresented: $showDaysSelection,
                        onDateSelected: { startDate, endDate in
                            fromDate = startDate
                            toDate = endDate
                            print("Selected From: \(fromDate), To: \(toDate)")
                            await weekOffData.fetchWeekOffData(startDate: fromDate, endDate: toDate) // ✅ allowed
                        }
                    )
                }
            }
            .onChange(of: fromDate) { newValue in
                Task {
                    await weekOffData.fetchWeekOffData(startDate: fromDate, endDate: toDate)
                }
            }
            // ✅ Trigger API when toDate changes
            .onChange(of: toDate) { newValue in
                Task {
                    await weekOffData.fetchWeekOffData(startDate: fromDate, endDate: toDate)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct WeeklyOffCard: View {
    let title: String
    @Binding var fromDate: Date
    @Binding var toDate: Date
    var onSubmit: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
            HStack(spacing: 10) {
                
                CustomDatePicker(selectedDate: $fromDate)
                CustomDatePicker(selectedDate: $toDate)
                
                Button(action: onSubmit) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.appPrimary)
                        .clipShape(Circle())
                }
                .frame(width: 40, height: 40)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color.backgroundColour)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

struct WeekOffRow: View {
    let item: weekOffResponse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Weekoff")
                    .font(.system(size: 14, weight: .medium))
                Spacer()
                Text(item.wkDate)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
                Text("- \(item.DtNm)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            Divider()
                .background(Color.black)
            Text("-")
                .foregroundColor(.black)
            
            HStack {
                Text("Submit on : ")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
                
                Text(item.sbmtOn)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}

struct CustomDatePicker: View {
    @Binding var selectedDate: Date
    @State private var showPicker = false
    
    var body: some View {
        Button(action: { showPicker.toggle() }) {
            HStack {
                Text(selectedDate.formattedAsYYYYMMDD())
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
                    .font(.system(size: 14))
                
                Spacer(minLength: 8)
                
                Image("calendar 1")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.appPrimary)
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
        }
        .sheet(isPresented: $showPicker) {
            VStack {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()
                Button("Done") { showPicker = false }
                    .padding()
            }
        }
    }
}

#Preview {
    weeklyOffView()
}

