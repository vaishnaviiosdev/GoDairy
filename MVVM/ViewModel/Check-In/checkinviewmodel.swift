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
    
    @Published var checkInSaveDataResponse: checkinSaveData?
    @Published var isCheckingIn: Bool = false
    @Published var checkInSuccessMsg: String = ""
    @Published var checkInSaveAlert = false
    
    func uploadImage(SFCode: String, image: UIImage, fileName: String) async throws -> String {
        guard let imgData = image.jpegData(compressionQuality: 0.5) else {
            throw NSError(domain: "Image Compression Error", code: -1, userInfo: nil)
        }
        
        let validFileName = fileName.hasSuffix(".jpg") ? fileName : "\(fileName).jpg"
        
        let imageUrl = "\(APIClient.shared.New_DBUrl)\(APIClient.shared.db_new_activity)upload/checkinimage&sfCode=\(SFCode)&FileName=\(validFileName)&Mode=ATTN"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: imageUrl)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(validFileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imgData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let rawResponse = String(data: data, encoding: .utf8) {
            print("🧾 Raw Response:")
            print(rawResponse)
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("📦 Status Code: \(httpResponse.statusCode)")
        }
        
        // You can decode or just return the filename
        return validFileName
    }
    
    func CheckInSavePosttt(
        shiftId: String,
        shiftName: String,
        shiftStart: String,
        shiftEnd: String,
        shiftCutOff: String,
        latitude: Double,
        longitude: Double,
        cnt: Int,
        wType: String,
        checkOnDuty: Int,
        selfieImage: UIImage,
        selfieImageData: Data,
        fileName: String
    ) async {
        let now = Date()
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeOnlyFormatter = DateFormatter()
        timeOnlyFormatter.dateFormat = "HH:mm:ss"

        let eDate = fullDateFormatter.string(from: now)
        let eTime = timeOnlyFormatter.string(from: now)

        guard selfieImage.jpegData(compressionQuality: 0.8) != nil else {
            print("❌ Failed to convert UIImage to JPEG data.")
            return
        }

        let timestamp = Int(Date().timeIntervalSince1970)
        let customFileName = "\(sf_code)_\(timestamp).jpg"

        do {
            let uploadedFileName = try await uploadImage(
                SFCode: sf_code,
                image: selfieImage,
                fileName: customFileName
            )
            
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
                "WrkType": wType,
                "CheckDutyFlag": cnt,
                "On_Duty_Flag": checkOnDuty,
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
                "slfy": uploadedFileName
            ]

            let orderedPayload: [[String: Any]] = [
                ["TP_Attendance": checkINData]
            ]

            let parameters: [String: Any] = [
                "data": orderedPayload
            ]
            
            let response: checkinSaveData = try await NetworkManager.shared.postFormData(
                urlString: checkIn_SaveUrl,
                parameters: parameters,
                responseType: checkinSaveData.self
            )
            
            DispatchQueue.main.async {
                self.checkInSaveDataResponse = response
                self.checkInSuccessMsg = response.Msg
                self.checkInSaveAlert = true
            }
            print("The CheckInSaveDataResponse is \(response)")
        }
        catch {
            self.checkInSuccessMsg = "Something Went Wrong. Try again later"
            self.checkInSaveAlert = true
            print("Error uploading check-in: \(error)")
        }
    }
    
    
    func CheckInSavePost(
        shiftId: String,
        shiftName: String,
        shiftStart: String,
        shiftEnd: String,
        shiftCutOff: String,
        latitude: Double,
        longitude: Double,
        cnt: Int,
        wType: String,
        checkOnDuty: Int,
        selfieImage: UIImage,
        selfieImageData: Data,
        fileName: String
    ) async {
        DispatchQueue.main.async {
            self.isCheckingIn = true
        } // START loader

        let now = Date()
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeOnlyFormatter = DateFormatter()
        timeOnlyFormatter.dateFormat = "HH:mm:ss"

        let eDate = fullDateFormatter.string(from: now)
        let eTime = timeOnlyFormatter.string(from: now)

        guard selfieImage.jpegData(compressionQuality: 0.8) != nil else {
            print("❌ Failed to convert UIImage to JPEG data.")
            DispatchQueue.main.async { self.isCheckingIn = false } // STOP loader
            return
        }

        let timestamp = Int(Date().timeIntervalSince1970)
        let customFileName = "\(sf_code)_\(timestamp).jpg"

        do {
            let uploadedFileName = try await uploadImage(
                SFCode: sf_code,
                image: selfieImage,
                fileName: customFileName
            )
            
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
                "WrkType": wType,
                "CheckDutyFlag": cnt,
                "On_Duty_Flag": checkOnDuty,
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
                "slfy": uploadedFileName
            ]

            let orderedPayload: [[String: Any]] = [
                ["TP_Attendance": checkINData]
            ]

            let parameters: [String: Any] = [
                "data": orderedPayload
            ]
            
            let response: checkinSaveData = try await NetworkManager.shared.postFormData(
                urlString: checkIn_SaveUrl,
                parameters: parameters,
                responseType: checkinSaveData.self
            )
            
            DispatchQueue.main.async {
                self.checkInSaveDataResponse = response
                self.checkInSuccessMsg = response.Msg
                self.checkInSaveAlert = true
                self.isCheckingIn = false // STOP loader
            }
            print("The CheckInSaveDataResponse is \(response)")
        }
        catch {
            DispatchQueue.main.async {
                self.checkInSuccessMsg = "Something Went Wrong. Try again later"
                self.checkInSaveAlert = true
                self.isCheckingIn = false // STOP loader
            }
            print("Error uploading check-in: \(error)")
        }
    }

}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
