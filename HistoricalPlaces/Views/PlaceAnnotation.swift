//
//  PlaceAnnotation.swift
//  HistoricalPlaces
//
//  Created by Jiayi Xu  on 2/9/17.
//  Copyright © 2017 Jiayi Xu All rights reserved.
//

import Foundation
import Mapbox

class PlaceAnnotation: NSObject, MGLAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    var placeModel:PlaceModel!

    public override init(){

        self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        super.init()
    }
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?,sourceModel:PlaceModel) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.placeModel = sourceModel;
    }
    
}
