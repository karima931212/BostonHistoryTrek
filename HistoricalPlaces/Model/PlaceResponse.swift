//
//  Place.swift
//  HistoricalPlaces
//
//  Created by Jiayi Xu on 2/7/17.
//  Copyright © 2017 Jiayi Xu. All rights reserved.
//

import Foundation
import ObjectMapper


enum PlaceTag:String{
    case General = "general"
    case All = "all"
    case Museum = "museum"
    case Park = "park"
    case Historic = "historic"
    case Stadium = "stadium"
}

class PlaceResponse: Mappable {

    var code:Int?
    var msg:String?
    var data:[PlaceModel]?

    required init?(map: Map){

    }

    func mapping(map: Map) {
        code <- map["code"]
        msg <- map["msg"]
        data <- map["data"]

    }
}


class PlaceModel : NSObject, NSCoding,Mappable{
    
    var address : String!
    var descriptionField : String!
    var distance:String!{
        didSet{
            if let dis = Double(distance ?? "0"){
                disDouble = dis
            }
        }
    }
    var mid : String!
    var latitude : String!
    var longitude : String!
    var name : String!
    var photoSize : String!
    var tag : String!
    var disDouble:Double = 0
    required init?(map: Map){
        
    }
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        address = dictionary["address"] as? String
        descriptionField = dictionary["description"] as? String
        distance = dictionary["distance"] as? String
        mid = dictionary["id"] as? String
        latitude = dictionary["latitude"] as? String
        longitude = dictionary["longitude"] as? String
        name = dictionary["name"] as? String
        photoSize = dictionary["photoSize"] as? String
        tag = dictionary["tag"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if address != nil{
            dictionary["address"] = address
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if distance != nil{
            dictionary["distance"] = distance
        }
        if mid != nil{
            dictionary["id"] = mid
        }
        if latitude != nil{
            dictionary["latitude"] = latitude
        }
        if longitude != nil{
            dictionary["longitude"] = longitude
        }
        if name != nil{
            dictionary["name"] = name
        }
        if photoSize != nil{
            dictionary["photoSize"] = photoSize
        }
        if tag != nil{
            dictionary["tag"] = tag
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        address = aDecoder.decodeObject(forKey: "address") as? String
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        distance = aDecoder.decodeObject(forKey: "distance") as? String
        mid = aDecoder.decodeObject(forKey: "mid") as? String
        latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        longitude = aDecoder.decodeObject(forKey: "longitude") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        photoSize = aDecoder.decodeObject(forKey: "photoSize") as? String
        tag = aDecoder.decodeObject(forKey: "tag") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if address != nil{
            aCoder.encode(address, forKey: "address")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if distance != nil{
            aCoder.encode(distance, forKey: "distance")
        }
        if mid != nil{
            aCoder.encode(mid, forKey: "mid")
        }
        if latitude != nil{
            aCoder.encode(latitude, forKey: "latitude")
        }
        if longitude != nil{
            aCoder.encode(longitude, forKey: "longitude")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if photoSize != nil{
            aCoder.encode(photoSize, forKey: "photoSize")
        }
        if tag != nil{
            aCoder.encode(tag, forKey: "tag")
        }
        
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? PlaceModel {
            if let lId = self.mid, let rId = rhs.mid {
                return lId == rId;
            }
        }
        return false;
    }
    
    public static func ==(lhs: PlaceModel, rhs: PlaceModel) -> Bool{
        if let lId = lhs.mid, let rId = rhs.mid {
            return lId == rId;
        }
        return false;
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        address <- map["address"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        tag <- map["tag"]
        descriptionField <- map["description"]
        photoSize <- map["photoSize"]
        mid <- map["id"]
        distance <- map["distance"]
        
    }

    
}

