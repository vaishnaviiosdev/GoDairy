//
//  Constant.swift
//  GoDairy
//
//  Created by San eforce on 18/08/25.
//

import Foundation

let sf_code = UserDefaults.standard.string(forKey: "Sf_code") ?? ""
let division_code = UserDefaults.standard.string(forKey: "Division_Code") ?? ""

let milk_url = "https://admin.godairy.in/server/milk_url_config.json"
let privacy_url = "https://admin.godairy.in/Privacy.html"
let worktype_url = "http://qa.godairy.in/server/Db_v310.php?axn=get/worktypes"
let leaveAvailability_url = "http://qa.godairy.in/server/Db_v300.php?axn=get/LeaveAvailabilityCheck&Year=2025&divisionCode=1&sfCode=MGR80&rSF=MGR80&State_Code=1"
let shiftTime_url = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl2 + "get%2FShift_timing&divisionCode=1&Sf_code=MGR80"
let save_LeaveRequestUrl = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl2 + "dcr/save&sf_name=G%20RAMESH&divisionCode=1&sfCode=MGR80&State_Code=1&desig=MGR"





