//
//  PlaceViewCell.swift
//  HistoricalPlaces
//
//  Created by Jiayi Xu on 2/7/17.
//  Copyright © 2017 Jiayi Xu. All rights reserved.
//

import Foundation
import UIKit

class PlaceViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!

    var placeModel:PlaceModel?{
        didSet{
            if placeModel != nil {
                nameLabel?.text = placeModel?.name

                switch placeModel!.tag ?? "" {
                case PlaceTag.Museum.rawValue:
                    icon.image = UIImage(named: "Museum")
                    tagLabel.text = "Museum";
                case PlaceTag.Park.rawValue:
                    icon.image = UIImage(named: "Park")
                    tagLabel.text = "Park";
                case PlaceTag.Historic.rawValue:
                    icon.image = UIImage(named: "Historic")
                    tagLabel.text = "Historic";
                case PlaceTag.Stadium.rawValue:
                    icon.image = UIImage(named: "Stadium")
                    tagLabel.text = "Stadium";
                default:
                    icon.image = UIImage(named: "Other")
                    tagLabel.text = "General";
                }


            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
