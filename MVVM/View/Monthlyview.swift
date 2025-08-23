//
//  Monthlyview.swift
//  GoDairy
//
//  Created by San eforce on 05/10/24.
//

import SwiftUI
import Alamofire

struct DashboardItem: Identifiable{
    let id = UUID()
    let leave:String
    let Permission:String
    let Advance:String
    let Newjoin:String
    let vwOnduty:String
    let vwmissedpunch:String
    let vwExtended:String
    let TountPlanCount:String
    let FlightAppr:String
    let HolidayCount:String
    let DeviationC:String
    let CancelLeave:String
    let ExpList:String
}
struct MonthlyItem: Identifiable{
    var id = UUID()
    let Count:Int
    let Name:String
    
}

struct Monthlyview: View {
    
 
  @State private var GetMonthly:[MonthlyItem] = []
  @State private var items:[DashboardItem] = [
//       DashboardItem(count: "15", label: "Permission"),
//       DashboardItem(count: "05", label: "Leave"),
//       DashboardItem(count: "05", label: "Late"),
//       DashboardItem(count: "15", label: "Early Arrival"),
//       DashboardItem(count: "05", label: "Shift Change"),
//       DashboardItem(count: "05", label: "Request")
           ]
    
  //  @State private var isNavigating =  false
    @State private var selectedItem: MonthlyItem? = nil
    @State private var navigateToNextPages = false
    @State private var isSubmitting = false
    @State private var navigatetoDashboard = false


    
    var body: some View {
        ScrollView{
            VStack(alignment:.leading,spacing: 10){
                
                Button(action: {
                    // Action for "View All" button (for now, let's assume it's for navigation)
                    self.selectedItem = nil // Or navigate to another screen, depending on your requirement.
                    // monthlyplan()
                }) {
                    ViewAll()
                    
                    
                }
                
                
                /*   Button(action: {
                 self.isNavigating = true // Update the state to trigger navigation
                 }) {
                 ViewAll() // Custom "View All" label
                 }
                 .background(
                 NavigationLink( destination: MonthlyPlan(),
                 label:{
                 ViewAll()
                 }) // Invisible link triggered by the button
                 .opacity(0)
                 )*/
                /*  NavigationLink(
                 destination:MonthlyPlan() ,
                 label: {
                 ViewAll()
                 
                 })*/
                
                
                //            HStack{
                //                Spacer()
                //                Text("View All")
                //                    .foregroundColor(colorData.shared.Appcolor)
                //                    .font(.system(size: 14))
                //                    .fontWeight(.bold)
                //            }
                //            .padding(1)
                
                LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())], spacing: 15){
                    ForEach(GetMonthly) { item in
                        
                        Button(action: {
                            // Action for tapping on each DashboardItem
                            self.selectedItem = item
                        }) {
                            ZStack{
                                VStack(spacing:5){
                                    Text("\(item.Count)")
                                        .font(.system(size: 20,weight: .bold))
                                        .foregroundColor(.appPrimary)
                                    
                                    Text(item.Name)
                                        .font(.system(size: 14))
                                        .foregroundColor(.black)
                                    
                                }
                                Spacer()
                                    .frame(maxWidth: .infinity)
                                    .padding(30)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                // .shadow(color:Color/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.1), radius: 5,x: 0,y: 2)
                            }
                        }
                    }
                }
            }
        }.onAppear{
            monthlyplan()
        }
        
        .padding()
        //.background(Color.gray.opacity(0.1))
    }


private func monthlyplan() {
   
   
    
   // navigateToNextPages = true
    
   
    //isSubmitting = true
//        DispatchQueue.main.async {
//            navigatetoDashboard = true
//        }
    var Sf_code:String=""
    var divisionCode:String = ""
    if let sfCode = UserDefaults.standard.string(forKey: "Sf_code") {
        Sf_code = sfCode
        print("Sf_code: \(sfCode)")
    }
    
    if let divCode = UserDefaults.standard.string(forKey: "Division_Code") {
        divisionCode = divCode
        print("Division_Code: \(divCode)")
    }
   
    
    let requestBody: [String: Any] = [
        "orderBy": "[\"name asc\"]",
        "desig": "mgr"
    ]

    
    let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
    let jsonString = String(data: jsonData!, encoding: .utf8)!
    let param: Parameters = ["data": jsonString]
    print(param)
    
    //http://qa.godairy.in/server/Db_v300.php?State_Code=1&desig=MGR&divisionCode=1&rSF=MGR80&axn=ViewAllCount&sfCode=MGR80
    
    let apiKey = "ViewAllCount&State_Code=1&desig=MGR&divisionCode=\(divisionCode)&rSF=MGR80&sfCode=MGR80"

        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL + apiKey, method: .post,parameters: param)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print(response)
                    if let plan = value as? [String:Any]{
                        print(plan)
//                        for plans in plan {
//                            let monthly = DashboardItem(leave: String(plan["leave"] as? Int ?? 0) , Permission: String(plan["permission"] as? Int ?? 0),Advance: plan["Advance"] as? String ?? "" ,Newjoin: plan["Newjoin"] as? String ?? "" ,vwOnduty: plan["vwOnduty"] as? String ?? "" ,vwmissedpunch: plan["vwmissedpunch"] as? String ?? "" ,vwExtended: plan["vwExtended"] as? String ?? "" ,TountPlanCount: plan["TountPlanCount"] as? String ?? "" ,FlightAppr: plan["FlightAppr"] as? String ?? "" ,HolidayCount: plan["HolidayCount"] as? String ?? "" ,DeviationC: plan["DeviationC"] as? String ?? "" ,CancelLeave: plan["CancelLeave"] as? String ?? "" ,ExpList: plan["ExpList"] as? String ?? "")
//                            items.append(monthly)
//                        }
//                        let monthly = DashboardItem(leave: String(plan["leave"] as? Int ?? 0) , Permission: String(plan["permission"] as? Int ?? 0),Advance: plan["Advance"] as? String ?? "" ,Newjoin: plan["Newjoin"] as? String ?? "" ,vwOnduty: plan["vwOnduty"] as? String ?? "" ,vwmissedpunch: plan["vwmissedpunch"] as? String ?? "" ,vwExtended: plan["vwExtended"] as? String ?? "" ,TountPlanCount: plan["TountPlanCount"] as? String ?? "" ,FlightAppr: plan["FlightAppr"] as? String ?? "" ,HolidayCount: plan["HolidayCount"] as? String ?? "" ,DeviationC: plan["DeviationC"] as? String ?? "" ,CancelLeave: plan["CancelLeave"] as? String ?? "" ,ExpList: plan["ExpList"] as? String ?? "")
//                        items.append(monthly)
                        
                        
                           print(items)
                        GetMonthly.append(MonthlyItem(Count:plan["leave"] as? Int ?? 0, Name: "Leave"))
                        GetMonthly.append(MonthlyItem(Count:plan["permission"] as? Int ?? 0, Name: "permission"))
                        GetMonthly.append(MonthlyItem(Count:plan["Advance"] as? Int ?? 0, Name: "Advance"))
                        GetMonthly.append(MonthlyItem(Count:plan["Newjoin"] as? Int ?? 0, Name: "Newjoin"))
                        GetMonthly.append(MonthlyItem(Count:plan["vwOnduty"] as? Int ?? 0, Name: "vwOnduty"))
                        GetMonthly.append(MonthlyItem(Count:plan["vwmissedpunch"] as? Int ?? 0, Name: "vwmissedpunch"))
                        GetMonthly.append(MonthlyItem(Count:plan["vwExtended"] as? Int ?? 0, Name: "vwExtended"))
                        GetMonthly.append(MonthlyItem(Count:plan["TountPlanCount"] as? Int ?? 0, Name: "TountPlanCount"))
                        GetMonthly.append(MonthlyItem(Count:plan["FlightAppr"] as? Int ?? 0, Name: "FlightAppr"))
                        GetMonthly.append(MonthlyItem(Count:plan["HolidayCount"] as? Int ?? 0, Name: "HolidayCount"))
                        GetMonthly.append(MonthlyItem(Count:plan["DeviationC"] as? Int ?? 0, Name: "DeviationC"))
                        GetMonthly.append(MonthlyItem(Count:plan["CancelLeave"] as? Int ?? 0, Name: "CancelLeave"))
                        GetMonthly.append(MonthlyItem(Count:plan["ExpList"] as? Int ?? 0, Name: "ExpList"))
                    }
                    
                  
                    
//                    DispatchQueue.main.async {
//                        isSubmitting = false
//                    }
//                    
//                    DispatchQueue.main.async {
//                        navigatetoDashboard = true
//                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }
   }

struct ViewAll:View {
    @State private var navigateToNextPages = false

    var body: some View {
        HStack{
           Spacer()
            Text("View All")
                .foregroundColor(.appPrimary)
                .font(.system(size: 14))
                .fontWeight(.bold)
        }
        .padding(1)
        
    }
}

#Preview {
    Monthlyview()
}
