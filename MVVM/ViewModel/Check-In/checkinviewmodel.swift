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
    
    func uploadImage(SFCode: String, image: UIImage, fileName: String) async throws -> String {
        print("The Uploadimage of image is \(image)")
        // 1. Compress the image
        guard let imgData = image.jpegData(compressionQuality: 0.5) else {
            throw NSError(domain: "Image Compression Error", code: -1, userInfo: nil)
        }

        // 2. Create the URL
        guard let url = URL(string: "http://qa.godairy.in/server/Db_v300.php?axn=imgupload&Slfypath=\(fileName)") else {
            throw NSError(domain: "Invalid URL", code: -2, userInfo: nil)
        }

        // 3. Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // 4. Set Content-Type for multipart/form-data
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // 5. Create multipart/form-data body
        var body = Data()

        // Add any additional parameters (e.g. SFCode)
        let parameters = ["SFCode": SFCode]
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }

        // Add the image data
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"imgfile\"; filename=\"\(fileName)\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imgData)
        body.append("\r\n")

        body.append("--\(boundary)--\r\n")
        request.httpBody = body

        // 6. Perform the upload using URLSession
        let (data, response) = try await URLSession.shared.data(for: request)

        // 7. Check for HTTP response status
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "Server Error", code: -3, userInfo: nil)
        }

        // 8. Convert response data to string
        guard let resultString = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "Response Parsing Error", code: -4, userInfo: nil)
        }
        print(resultString)

        return resultString
    }

    
    
    
//    func uploadImage(SFCode: String, image: UIImage, fileName: String) async throws -> String {
//        // Compress the image to reduce the size
//        guard let imgData = image.jpegData(compressionQuality: 0.50) else {
//            throw NSError(domain: "Image Compression Error", code: -1, userInfo: nil)
//        }
//        
//        let uploadURL = "http://qa.godairy.in/server/Db_v300.php?axn=imgupload&Slfypath=\(fileName)"
//        
//        
//        // Prepare the parameters for the request (you can add other parameters if needed)
//        let parameters: [String: Any] = [
//            "sf_code": SFCode
//        ]
//        
//        let result: ImageUploadResponse = try await NetworkManager.shared.uploadMultipart(
//            urlString: uploadURL,
//            parameters: parameters,
//            imageData: imgData,
//            imageFieldName: "Slfypath", // Field name for image upload
//            fileName: fileName,
//            mimeType: "image/jpg", // Assuming image is in JPG format
//            responseType: ImageUploadResponse.self // Your model for the response
//        )
//        
//        print("Upload successful: \(result)") // Process the result as needed
//        
//        return fileName // Return file name (or other response data you need)
//    }
    
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
        let now = Date()
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeOnlyFormatter = DateFormatter()
        timeOnlyFormatter.dateFormat = "HH:mm:ss"

        let eDate = fullDateFormatter.string(from: now)
        let eTime = timeOnlyFormatter.string(from: now)

        // Prepare the check-in data
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
            "slfy": fileName // The filename after the image upload is completed
        ]
        
        print("The CheckInData Payload is \(checkINData)")
        print("The selfie Image Data is \(selfieImageData)")

        let orderedPayload: [[String: Any]] = [
            ["TP_Attendance": checkINData]
        ]
        print(checkINData)

        
        let parameters: [String: Any] = [
            "data": "[{\"TP_Attendance\":{\"Mode\":\"CIN\",\"Divcode\":\"1\",\"sfCode\":\"MGR80\",\"Shift_Selected_Id\":\"4\",\"Shift_Name\":\"Shift 3\",\"ShiftStart\":\"09:00 AM\",\"ShiftEnd\":\"06:00 PM\",\"ShiftCutOff\":\"2024-12-03 23:59:59\",\"App_Version\":\"v2.3_T4\",\"WrkType\":0,\"CheckDutyFlag\":0,\"On_Duty_Flag\":0,\"vstRmks\":\"\",\"eDate\":\"2024-12-03 11:59:41\",\"eTime\":\"11:59:41\",\"UKey\":\"MGR80-1733207374023\",\"lat\":13.0299732,\"long\":80.2413935,\"Lattitude\":13.0299732,\"Langitude\":80.2413935,\"PlcNm\":\"\",\"PlcID\":\"\",\"slfy\":\"MGR80_1733207376.jpg\"}}]"
        ]
        
        print(parameters)
        do {
            // Upload the image first (this will return the file name after success)
            let uploadedFileName = try await uploadImage(SFCode: sf_code, image: selfieImage, fileName: fileName)
            
             //After the image upload is successful, upload the check-in data
            let response: checkinSaveData = try await NetworkManager.shared.uploadMultipart(
                urlString: checkIn_SaveUrl,
                parameters: parameters,
                imageData: selfieImageData,
                imageFieldName: "slfy", // field name expected by backend
                fileName: uploadedFileName,
                mimeType: "image/jpg",
                responseType: checkinSaveData.self // You can use your own response model
            )
            
            self.checkInSaveDataResponse = response
            
        } catch {
            print("Error uploading check-in: \(error)")
        }
    }


    
//    func CheckInSavePost(
//        shiftId: String,
//        shiftName: String,
//        shiftStart: String,
//        shiftEnd: String,
//        shiftCutOff: String,
//        latitude: Double,
//        longitude: Double,
//        cnt: Int,
//        wType: String,
//        checkOnDuty: Int,
//        selfieImage: UIImage,
//        selfieImageData: Data,
//        fileName: String
//    ) async {
//        let now = Date()
//        let fullDateFormatter = DateFormatter()
//        fullDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let timeOnlyFormatter = DateFormatter()
//        timeOnlyFormatter.dateFormat = "HH:mm:ss"
//
//        let eDate = fullDateFormatter.string(from: now)
//        let eTime = timeOnlyFormatter.string(from: now)
//
//        let checkINData: [String: Any] = [
//            "Mode": "CIN",
//            "Divcode": division_code,
//            "sfCode": sf_code,
//            "Shift_Selected_Id": shiftId,
//            "Shift_Name": shiftName,
//            "ShiftStart": shiftStart,
//            "ShiftEnd": shiftEnd,
//            "ShiftCutOff": shiftCutOff,
//            "App_Version": appVersion ?? "",
//            "WrkType": wType,
//            "CheckDutyFlag": cnt,
//            "On_Duty_Flag": checkOnDuty,
//            "vstRmks": "",
//            "eDate": eDate,
//            "eTime": eTime,
//            "UKey": Ukey,
//            "lat": latitude,
//            "long": longitude,
//            "Lattitude": latitude,
//            "Langitude": longitude,
//            "PlcNm": "",
//            "PlcID": "",
//            "slfy": fileName // Just the filename (server might use this for linking)
//        ]
//        
//        print("The CheckInData Payload is \(checkINData)")
//        print("The selfie Image Data is \(selfieImageData)")
//
//        let orderedPayload: [[String: Any]] = [
//            ["TP_Attendance": checkINData]
//        ]
//
//        let parameters: [String: Any] = [
//            "data": orderedPayload
//        ]
//        
//        do {
//            let response: checkinSaveData = try await NetworkManager.shared.uploadMultipart(
//                urlString: checkIn_SaveUrl,
//                parameters: parameters,
//                imageData: selfieImageData,
//                imageFieldName: "slfy", // field name expected by backend
//                fileName: fileName,
//                mimeType: "image/jpg", responseType: checkinSaveData.self
//            )
//            self.checkInSaveDataResponse = response
//        } catch {
//            print("Error uploading check-in: \(error)")
//        }
//    }
    

    

}
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
