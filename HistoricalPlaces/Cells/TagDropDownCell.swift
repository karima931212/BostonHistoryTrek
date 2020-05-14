//
//  TagDropDownCell.swift
//  HistoricalPlaces
//
//  Created by Jiayi Xu on 2017/3/12.
//  Copyright © 2017年 Jiayi Xu All rights reserved.
//

import UIKit
import DropDown

class TagDropDownCell: DropDownCell {


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func setSelected(_ selected: Bool, animated: Bool) {
        if (!selected){

            self.backgroundColor = UIColor.white;
            self.optionLabel.textColor = UIColor.black

        }else{

            self.backgroundColor = ColorPalette.Purple

            self.optionLabel.textColor = UIColor.white
        }
    }

}
