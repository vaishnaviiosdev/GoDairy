//
//  primaryordermodel.swift
//  GoDairy
//
//  Created by San eforce on 10/10/25.
//

import Foundation

struct primaryOrderData: Codable, Identifiable {
    var id = UUID().uuidString
    //let id: String
    let StateCode: String?
    let orderTaken: Int?
    let name: String?
    let Out_stand: Int?
    let overDue: Int?
    let Town_Code: String?
    let Town_Name: String?
    let Addr1: String?
    let Addr2: String?
    let City: String?
    let Pincode: String?
    let GSTN: String?
    let FSSAI: String?
    let lat: String?
    let long: String?
    let addrs: String?
    let Mobile: String?
    let Tcode: String?
    let Dis_Cat_Code: String?
    let ERP_Code: String?
    let DivERP: String?
    let Latlong: String?
    let CusSubGrpErp: String?
    let flag: String?
    let remarks: String?
}
