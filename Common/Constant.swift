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

let milk_url = "https://admin.godairy.in/server/milk_url_config.json"
let privacy_url = "https://admin.godairy.in/Privacy.html"
let worktype_url = "http://qa.godairy.in/server/Db_v310.php?axn=get/worktypes"
let leaveAvailability_url = "http://qa.godairy.in/server/Db_v300.php?axn=get/LeaveAvailabilityCheck&Year=2025&divisionCode=1&sfCode=MGR80&rSF=MGR80&State_Code=1"
let shiftTime_url = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl2 + "get%2FShift_timing&divisionCode=1&Sf_code=MGR80"
let save_LeaveRequestUrl = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl2 + "dcr/save&sf_name=G%20RAMESH&divisionCode=1&sfCode=MGR80&State_Code=1&desig=MGR"
let advanceType_url = APIClient.shared.New_DBUrl + APIClient.shared.DBURL2 + "get%2FAdvtypes"
let leaveTypes_url = APIClient.shared.New_DBUrl + "/server/Db_v300.php?&State_Code=1&divisionCode=1&rSF=MGR80&axn=table%2Flist&sfCode=MGR80"
let save_AdvanceRequestUrl = APIClient.shared.New_DBUrl + "/server/Db_v310.php?&axn=save%2Fadvance"
let permission_shiftTimeUrl = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl2 + "get%2FShift_timing&divisionCode=1&Sf_code=MGR80"
let permission_takenHrsUrl = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl2 + "get/tknPerm&PDt=06-01-2025&divisionCode=1&sfCode=MGR80&rSF=MGR80&State_Code=1"
let permission_saveUrl = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl2 + "dcr/save&sf_name=G%20RAMESH&divisionCode=1&sfCode=MGR80&State_Code=MGR80&desig=MGR"
let missedPunchUrl = APIClient.shared.New_DBUrl + APIClient.shared.DBURL + "GetMissed_Punch&divisionCode=1&sfCode=MGR80&rSF=MGR80&State_Code=1"
let missedPunch_SaveUrl = APIClient.shared.New_DBUrl + APIClient.shared.DBURL + "dcr/save&sf_name=G%20RAMESH&Ekey=EKMGR80995194743&divisionCode=1&sfCode=MGR80&State_Code=1&desig=MGR"
let weekoffEntry_saveUrl = APIClient.shared.New_DBUrl + APIClient.shared.DBURL + "dcr/save&id=wk&divisionCode=1&sfCode=MGR80&rSF=MGR80&State_Code=1"

//http://qa.godairy.in/server/Db_v300.php?axn=dcr/save&id=wk&divisionCode=1&sfCode=MGR80&rSF=MGR80&State_Code=1














