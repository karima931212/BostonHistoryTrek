//
//  NavigationController.swift
//  HistoricalPlaces
//
//  Created by Jiayi Xu on 2017/2/28.
//  Copyright © 2017年 Jiayi Xu. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {


    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
