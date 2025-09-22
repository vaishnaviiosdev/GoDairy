//
//  Constant.swift
//  GoDairy
//
//  Created by San eforce on 18/08/25.
//

import Foundation

let form_Data_ContentType = "application/x-www-form-urlencoded"
let sf_code = UserDefaults.standard.string(forKey: "Sf_code") ?? ""
let Ukey = String(format: "EK%@-%i", sf_code,Int(Date().timeIntervalSince1970))
let division_code = UserDefaults.standard.string(forKey: "Division_Code") ?? ""
let sf_name = UserDefaults.standard.string(forKey: "Sf_Name") ?? ""
let sf_Designation = UserDefaults.standard.string(forKey: "sf_Designation_Short_Name") ?? ""

let milk_url = "https://admin.godairy.in/server/milk_url_config.json"
let privacy_url = "https://admin.godairy.in/Privacy.html"
let worktype_url = APIClient.shared.New_DBUrl + APIClient.shared.DBURL2 + "get/worktypes"

//Request
let leaveAvailability_url = APIClient.shared.New_DBUrl + APIClient.shared.DBURL + "get/LeaveAvailabilityCheck&Year=2025&divisionCode=\(division_code)&sfCode=\(sf_code)&rSF=\(sf_code)&State_Code=1"

let shiftTime_url = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl2 + "get%2FShift_timing&divisionCode=\(division_code)&Sf_code=\(sf_code)"

let save_LeaveRequestUrl = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl2 + "dcr/save&sf_name=\(sf_name)&divisionCode=\(division_code)&sfCode=\(sf_code)&State_Code=1&desig=MGR"

let advanceType_url = APIClient.shared.New_DBUrl + APIClient.shared.DBURL2 + "get%2FAdvtypes"

let leaveTypes_url = APIClient.shared.New_DBUrl + "/server/Db_v300.php?&State_Code=1&divisionCode=\(division_code)&rSF=\(sf_code)&axn=table%2Flist&sfCode=\(sf_code)"

let save_AdvanceRequestUrl = APIClient.shared.New_DBUrl + APIClient.shared.DBURL3 + "save%2Fadvance"

let permission_shiftTimeUrl = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl2 + "get%2FShift_timing&divisionCode=\(division_code)&Sf_code=\(sf_code)"

let permission_takenHrsUrl = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl2 + "get/tknPerm&PDt=06-01-2025&divisionCode=\(division_code)&sfCode=\(sf_code)&rSF=\(sf_code)&State_Code=1"

let permission_saveUrl = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl2 + "dcr/save&sf_name=\(sf_name)&divisionCode=\(division_code)&sfCode=\(sf_code)&State_Code=\(sf_code)&desig=MGR"

let missedPunchUrl = APIClient.shared.New_DBUrl + APIClient.shared.DBURL + "GetMissed_Punch&divisionCode=\(division_code)&sfCode=\(sf_code)&rSF=\(sf_code)&State_Code=1"

let missedPunch_SaveUrl = APIClient.shared.New_DBUrl + APIClient.shared.DBURL + "dcr/save&sf_name=\(sf_name)&Ekey=\(Ukey)&divisionCode=\(division_code)&sfCode=\(sf_code)&State_Code=1&desig=MGR"

let weekoffEntry_saveUrl = APIClient.shared.New_DBUrl + APIClient.shared.DBURL + "dcr/save&id=wk&divisionCode=\(division_code)&sfCode=\(sf_code)&rSF=\(sf_code)&State_Code=1"

let DeviationEntry_Url = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl3 + "&State_Code=1&divisionCode=\(division_code)&rSF=\(sf_code)&axn=table%2Flist&sfCode=\(sf_code)"

let DeviationEntry_SaveUrl = APIClient.shared.New_DBUrl + APIClient.shared.DBURL2 + "save/exception&sf_name=\(sf_name)&divisionCode=\(division_code)&sfCode=\(sf_code)&State_Code=1&desig=MGR"

//Status
let leaveStatus_Url = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "AMod=null&divisionCode=\(division_code)&sfCode=\(sf_code)&rSF=\(sf_code)&State_Code=1&axn=GetLeave_Status"

let missedPunch_Url = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "AMod=0&divisionCode=\(division_code)&sfCode=\(sf_code)&rSF=\(sf_code)&State_Code=1&axn=GetMissedPunch_Status"

let leaveCancelStatus_Url = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "AMod=0&divisionCode=\(division_code)&sfCode=\(sf_code)&rSF=\(sf_code)&State_Code=1&axn=GetLeaveCancel_Status"

//Dashboard
let myDayPlanCheck_Url = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "desig=MGR&divisionCode=\(division_code)&Sf_code=\(sf_code)&axn=check%2Fmydayplan&Date=\(Date())%2014%3A46%3A13"



let myDayPlanSave_Url = APIClient.shared.New_DBUrl + APIClient.shared.db_new_activity1 + "State_Code=1&desig=MGR&divisionCode=\(division_code)&axn=save/dayplandynamic&sfCode=\(sf_code)"

//My Approval
let missedPunchApproval_Url = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "divisionCode=\(division_code)&sfCode=\(sf_code)&rSF=\(sf_code)&State_Code=1&axn=vwmissedpunch"
let leaveApproval_Url = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "divisionCode=\(division_code)&sfCode=\(sf_code)&rSF=\(sf_code)&State_Code=1&axn=vwLeave"
let leaveApproval_ApprovalUrl = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "State_Code=1&desig=MGR&divisionCode=\(division_code)&Ukey=\(Ukey)&To_Date=:\("")&axn=dcr/save&Sf_Code=\(sf_code)&From_Date=:\("")&No_of_Days=:\("")&sfCode=\(sf_code)&leaveid=522"
let leaveApproval_RejectUrl = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "State_Code=1&desig=MGR&divisionCode=\(division_code)&Ukey=\(Ukey)&To_Date=:\("")&axn=dcr/save&Sf_Code=\(sf_code)&From_Date=:\("")&No_of_Days=:\("")&sfCode=\(sf_code)&leaveid=524"

let permissionApproval_Url = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "divisionCode=\(division_code)&sfCode=\(sf_code)&rSF=\(sf_code)&State_Code=1&axn=ViewPermission"

// http://qa.godairy.in/server/Db_v300.php?divisionCode=1&sfCode=MGR80&rSF=MGR80&State_Code=1&axn=ViewPermission

//http://qa.godairy.in/server/Db_v300.php?State_Code=1&desig=MGR&divisionCode=1&Ukey=EKMGR80946553665&To_Date=:22/09/2025&axn=dcr/save&Sf_Code=MGR9366&From_Date=:22/09/2025&No_of_Days=:1.0&sfCode=MGR80&leaveid=524


//Approval History
let permissionHistoryApproval_Url = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "AMod=1&divisionCode=\(division_code)&sfCode=\(sf_code)&rSF=\(sf_code)&State_Code=1&axn=GetPermission_Status"
let missedPunchHistoryApproval_Url = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "AMod=1&divisionCode=\(division_code)&sfCode=\(sf_code)&rSF=\(sf_code)&State_Code=1&axn=GetMissedPunch_Status"


let leaveApprovalHistory_Url = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "AMod=1&divisionCode=\(division_code)&sfCode=\(sf_code)&rSF=\(sf_code)&State_Code=1&axn=GetLeave_Status"


let advanceApprovalHistory_Url = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "&desig=MGR&divisionCode=\(division_code)&sfCode=\(sf_code)&rSF=\(sf_code)&State_Code=1&axn=GetAdvance_Status_AMOD"






















