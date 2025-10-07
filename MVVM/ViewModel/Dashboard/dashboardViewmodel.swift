//
//  dashboardViewmodel.swift
//  GoDairy
//
//  Created by San eforce on 19/09/25.
//

import Foundation
import SwiftUI

@MainActor
class dashboardViewModel: ObservableObject {
    @Published var dashboardData: mydayPlanCheckResponse?
    @Published var monthlyData: monthlyDashboardData?
    @Published var workTypesData: [mydayplanworkTypeResponse] = []
    @Published var checkDayPlanData: [CheckDayPlanData] = []
    @Published var btnTitle: String = ""
    @Published var btnBackgroundColor: Color = Color.appPrimary
    @Published var todayPlanData: [TodayData] = []
    @Published var monthlyViewallData: [monthlyViewAllData] = []
    @Published var shiftTimeRange: String = ""
    @Published var checkInDate: String = ""
    @Published var AttTm: String = ""
    @Published var ET: String = ""
    @Published var InTimeImageStr: String = ""
    @Published var OutTimeImageStr: String = ""
    @Published var GeoIn: String = ""
    @Published var GeoOut: String = ""
    @Published var submitData: SubmitDayPlanData?
    @Published var showDayPlanSaveAlert = false
    @Published var showDayPlanSuccessMsg: String = ""
    @Published var WorkTypeName: [String] = []
    @Published var WorkTypeID: [Int] = []
    @Published var WorkTypeFlag: [String] = []
    @Published var Todaycheckin_Flag: Int = 0
    @Published var isFirstTimeCheckIn : Bool = false
    private var timer: Timer?
    private var checkInTime: Date?
    
    func fetchDashboardData() async {
        do {
            let formattedTodayDate = Date().formattedAsYYYYMMDD()
            
            let myDayPlan_Url = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "desig=MGR&divisionCode=\(division_code)&Sf_code=\(sf_code)&axn=check%2Fmydayplan&Date=\(formattedTodayDate)%2014%3A46%3A13"
            
            let response: mydayPlanCheckResponse = try await NetworkManager.shared.fetchData(from: myDayPlan_Url, as: mydayPlanCheckResponse.self
            )
            
            DispatchQueue.main.async {
                self.dashboardData = response
                self.Todaycheckin_Flag = self.dashboardData?.Todaycheckin_Flag ?? 0
                self.checkDayPlanData = response.Checkdayplan ?? []
                self.updateBtnAppearance() // ✅ update title/color
            }
            print("the Todaycheckin_Flag is \(Todaycheckin_Flag)")
            print("the CheckDayPlanData is \(self.checkDayPlanData)")
        }
        catch {
            print("Error Fetching Data is \(error)")
        }
    }
    
    private func saveCheckInTime(_ date: Date) {
        UserDefaults.standard.set(date, forKey: "checkInTime")
    }

    private func loadCheckInTime() -> Date? {
        return UserDefaults.standard.object(forKey: "checkInTime") as? Date
    }
    
    func startCheckOutTimer() {
        if let savedTime = loadCheckInTime() {
            checkInTime = savedTime
        }
        else {
            checkInTime = Date() // First time check-in
            saveCheckInTime(checkInTime!)
        }

        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateCheckOutButtonTitle()
            }
        }
    }

    func updateBtnAppearance() {
        if dashboardData?.CheckEndKM ?? 0 == 1 && dashboardData?.Todaycheckin_Flag == 1 /*dashboardData?.CheckMOT ?? 0 == 1 */{
            // ✅ User has checked in already → start Check-Out timer
            startCheckOutTimer()
        }
        else if dashboardData?.CheckEndDT != "" && dashboardData?.Todaycheckin_Flag == 0 {
            //Redirect to Expense Page
            //Expense Page not worked now
            //For Now only we redirect to the Check In Page
            btnTitle = "Check In"
            btnBackgroundColor = .appPrimary
            isFirstTimeCheckIn = true
            stopCheckOutTimer()
            
        }
        //This is Actual Check-In Redirection
//        else if dashboardData?.CheckEndDT != "" && dashboardData?.Todaycheckin_Flag == 0 {
//            print("This is First Time Check In Called")
//            // ✅ First-time check-in
//            btnTitle = "Check In"
//            btnBackgroundColor = .appPrimary
//            isFirstTimeCheckIn = true
//            stopCheckOutTimer()
//        }
        else if dashboardData?.CheckEndDT == "" && dashboardData?.Todaycheckin_Flag == 1 {
            print("This is Second Time Check In Called")
            // ✅ Second-time check-in (after break)
            btnTitle = "Check In"
            btnBackgroundColor = .appPrimary
            isFirstTimeCheckIn = false
            stopCheckOutTimer()
        }
        else if dashboardData?.Checkdayplan?.isEmpty ?? true {
            btnTitle = "My Day Plan"
            btnBackgroundColor = .appPrimary
        }
        else {
            btnTitle = "-----"
            btnBackgroundColor = .appPrimary
            // ✅ Default (no plan yet)
//            btnTitle = "My Day Plan"
//            btnBackgroundColor = .appPrimary
//            stopCheckOutTimer(resetTitle: false)
        }
    }

    func submitCheckOut() async {
        print("User Tabs the CheckOut Button")
    }
    
    private func updateCheckOutButtonTitle() {
        guard let checkInTime = checkInTime else { return }
        let elapsed = Date().timeIntervalSince(checkInTime)
        let timeString = secondsToHMS(Int(elapsed))

        DispatchQueue.main.async {
            self.btnTitle = "CHECK OUT (\(timeString))"
            self.btnBackgroundColor = Color.appSecondary2
        }
    }
    
    func stopCheckOutTimer(resetTitle: Bool = true) {
        timer?.invalidate()
        timer = nil
        clearCheckInTime()
        if resetTitle {
            btnTitle = "Check In"
        }
    }
    
    private func clearCheckInTime() {
        UserDefaults.standard.removeObject(forKey: "checkInTime")
    }

    private func secondsToHMS(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
    
    //worktype_url
    func fetchWorkTypeDataPost() async {
        let workTypePayload: [String: Any] = [
            "SF": sf_code,
            "div": division_code
        ]
        
        let parameters: [String: Any] = [
            "data": workTypePayload
        ]
        
        do {
            let response: [mydayplanworkTypeResponse] = try await NetworkManager.shared.postFormData(
                urlString: worktype_url,
                parameters: parameters,
                responseType: [mydayplanworkTypeResponse].self
            )
            self.workTypesData = response
           
            await MainActor.run {
                self.WorkTypeName = response.map { $0.name }
                self.WorkTypeID = response.map { $0.id }
                self.WorkTypeFlag = response.map { $0.FWFlg }
            }
        }
        catch {
            print("Error Fetching Data is \(error)")
        }
    }
    
    func SubmitMyDayPlanPost(workTypeCode: Int, workType_Name: String,remarks: String, fwFlag: String) async {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" 
        formatter.timeZone = .current  // optional, ensures local timezone

        let formattedDate = formatter.string(from: now)
        
        let tpDayPlan: [String: Any] = [
            "worktype_code": workTypeCode,
            "dcr_activity_date": formattedDate,
            "worktype_name": workType_Name,
            "Ekey": Ukey,
            "objective": remarks,
            "Flag": fwFlag,
            "Button_Access": "",
            "MOT": "",
            "DA_Type": "",
            "Driver_Allow": "0",
            "From_Place": "",
            "To_Place": "",
            "MOT_ID": "",
            "To_Place_ID": "",
            "Mode_Travel_ID": "",
            "worked_with": "null",
            "jointWorkCode": "null"
        ]
        
        let parameters: [String: Any] = [
            "data": [
                [
                   "Tp_Dayplan": tpDayPlan,
                   "Tp_DynamicValues": []
                ]
            ]
        ]
        
        do {
            let response: SubmitDayPlanData = try await NetworkManager.shared.postFormData(urlString: myDayPlanSave_Url, parameters: parameters, responseType: SubmitDayPlanData.self
            )
            self.submitData = response
            self.showDayPlanSuccessMsg = "Day Plan Submitted Successfully"
            self.showDayPlanSaveAlert = true
            await self.fetchDashboardData()
        }
        catch {
            self.showDayPlanSuccessMsg = "\(error)"
            self.showDayPlanSaveAlert = true
            print("Error Fetching Data is \(error)")
        }
    }
    
    func getTodayData() async {
        do {
            let response: [TodayData] = try await NetworkManager.shared.fetchData(from: todayDashboard_Url, as: [TodayData].self
            )
            DispatchQueue.main.async {
                self.todayPlanData = response
                
                if let first = self.todayPlanData.first,
                   let start = first.Shft?.date,
                   let end = first.ShftE?.date {
                    
                    self.shiftTimeRange = formatShiftTime(start: start, end: end)
                    self.checkInDate = first.AttDate
                    self.AttTm = first.AttTm
                    self.ET = first.ET
                    self.InTimeImageStr = first.EImgName
                    self.OutTimeImageStr = first.SImgName
                    self.GeoIn = first.GeoIn ?? ""
                    self.GeoOut = first.GeoOut ?? ""
                    print("The shiftTimeRange is \(self.shiftTimeRange)")
                }
                else {
                    self.shiftTimeRange = "No shift data"
                    print("todayPlanData is empty or missing values")
                }
            }
        }
        catch {
            print("Error fetching data is \(error)")
        }
    }
    
    func getMonthlyDashboardData() async {
        do {
            let response: monthlyDashboardData = try await NetworkManager.shared.fetchData(from: monthlyDashboard_Url, as: monthlyDashboardData.self
            )
            self.monthlyData = response
            print("The Monthly Data response is \(response)")
        }
        catch {
            print("Error fetching data is \(error)")
        }
    }
    
    func getMonthlyDashboardViewAllData() async {
        do {
            let response: [monthlyViewAllData] = try await NetworkManager.shared.fetchData(from: monthlyViewAll_Url, as: [monthlyViewAllData].self
            )
            self.monthlyViewallData = response
        }
        catch {
            print("Error fetching data is \(error)")
        }
    }
}

extension dashboardViewModel {
    func getWorkTypeDetails(for name: String) -> (id: Int?, flag: String?) {
        if let index = WorkTypeName.firstIndex(of: name) {
            let id = WorkTypeID[index]
            let flag = WorkTypeFlag[index]
            return (id, flag)
        }
        return (nil, nil)
    }
}


