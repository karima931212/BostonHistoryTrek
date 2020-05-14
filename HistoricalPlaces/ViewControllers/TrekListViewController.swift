//
//  TrekListViewController.swift
//  HistoricalPlaces
//
//  Created by Jiayi Xu on 2017/4/22.
//  Copyright © 2017年 Jiayi Xu. All rights reserved.
//

import UIKit

class TrekListViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
            }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.contentInset = UIEdgeInsets.zero

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyLocationHelper.sharedInstanced.getArray().count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrekCell
        cell.topline.isHidden = indexPath.row == 0
        cell.bottomLine.isHidden = indexPath.row == MyLocationHelper.sharedInstanced.getArray().count-1
        cell.model = MyLocationHelper.sharedInstanced.getArray()[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaceDetailViewController") as? PlaceDetailViewController {
            
            self.navigationController?.pushViewController(vc, animated: true)
            vc.model = MyLocationHelper.sharedInstanced.getArray()[indexPath.row]
        }
    }
}
