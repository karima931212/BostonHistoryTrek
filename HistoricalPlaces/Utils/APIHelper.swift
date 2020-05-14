//
//  NetworkHelper.swift
//  HistoricalPlaces
//
//  Created by Jiayi Xu on 2017/2/28.
//  Copyright © 2017年 Jiayi Xu. All rights reserved.
//

import UIKit
import Alamofire

class APIHelper {

    private static let serverAddress = "https://historicalplaces.azurewebsites.net";
    
    public static let getPlaceList = APIHelper.serverAddress + "/search/serve.php"
    public static let getPlaceDetail = APIHelper.serverAddress + "/search/details.php"

    public class func genSecret(uuid:String)->String {
        let salt:String = "The_Quick_Brown_Fox@"
        let preSecret:String = (uuid.data(using: .utf8)?.base64EncodedString())! + salt
        return (preSecret.data(using: .utf8)?.base64EncodedString())!
    }
}
