//
//  checkinviewmodel.swift
//  GoDairy
//
//  Created by San eforce on 30/09/25.
//

import Foundation
import SwiftUI

@MainActor
class Checkinviewmodel: ObservableObject {
    func CheckInSavePost(shiftId: String, shiftName: String, shiftStart: String, shiftEnd: String, shiftCutOff: String, latitude: String, longitude: String) async {
        
        let now = Date()
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeOnlyFormatter = DateFormatter()
        timeOnlyFormatter.dateFormat = "HH:mm:ss"
        
        let eDate = fullDateFormatter.string(from: now)
        let eTime = timeOnlyFormatter.string(from: now)
        
        let checkINData: [String: Any] = [
                "Mode": "CIN",
                "Divcode": division_code,
                "sfCode": sf_code,
                "Shift_Selected_Id": shiftId,
                "Shift_Name": shiftName,
                "ShiftStart": shiftStart,
                "ShiftEnd": shiftEnd,
                "ShiftCutOff": shiftCutOff,
                "App_Version": appVersion ?? "",
                "WrkType": "0", //wrktype
                "CheckDutyFlag": "0", //CntValue
                "On_Duty_Flag": "0", //checkonduty
                "vstRmks": "",
                "eDate": eDate,
                "eTime": eTime,
                "UKey": Ukey,
                "lat": latitude,
                "long": longitude,
                "Lattitude": latitude,
                "Langitude": longitude,
                "PlcNm": "",
                "PlcID": "",
                "slfy": "MGR80_1733207376.jpg"
            ]
        
        print("The CheckInData is \(checkINData)")
    }
}
