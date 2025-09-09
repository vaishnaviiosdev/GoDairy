//
//  APIClient.swift
//  GoDairy
//
//  Created by Mani V on 28/09/24.
//

import Foundation

class APIClient {
    static let shared = APIClient()
    var BaseURL: String = "https://godairy.in"
    var DBURL="/server/Db_v300.php?axn="
    
    var DBURL2 = "/server/Db_v310.php?axn="
    var DBURL3 = "/server/Db_v310.php?&axn="
    var db_new_activity = "/server/db_new_activity.php?axn="
    
    var New_DBUrl = "http://qa.godairy.in"//Current
    var New_DBUrl2 = "/server/Db_v300.php?&axn="
    var New_DBUrl3 = "/server/Db_V13.php?"
    var New_DBUrl4 = "/server/Db_v300.php?"
    //https://godairy.in/server/Db_v310.php?axn=get/worktypes
}


