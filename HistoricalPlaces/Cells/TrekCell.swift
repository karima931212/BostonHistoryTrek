//
//  TrekCell.swift
//  HistoricalPlaces
//
//  Created by Jiayi Xu 2017/4/22.
//  Copyright © 2017年 Jiayi Xu .All rights reserved.
//

import UIKit
import MapKit

class TrekCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var topline: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model:PlaceModel!{
        didSet{
            if model != nil{
                label.text = model.name
            }
        }
    }

    @IBAction func go(_ sender: Any) {
        if model == nil { return }
        
        guard let lon = Double(model!.longitude!) ,let lat = Double(model!.latitude!) else {return}
        
        
        var currentLoc = MKMapItem.forCurrentLocation()
        var toLocation = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude:lon)))
        MKMapItem.openMaps(with: [currentLoc,toLocation], launchOptions: [
            MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
            
            MKLaunchOptionsShowsTrafficKey:true
            ])
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
