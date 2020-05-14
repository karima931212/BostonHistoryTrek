//
//  PlaceListViewController.swift
//  HistoricalPlaces
//
//  Created by Jiayi Xu on 2017/2/28.
//  Copyright © 2017年 Jiayi XU. All rights reserved.
//

import UIKit

class PlaceListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var sourceData:[PlaceModel]!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView();
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 77;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func reloadList(sourceData:[PlaceModel]?){
        if let arr = sourceData, arr.count > 0 {
            self.sourceData = sourceData;
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourceData?.count ?? 0 ;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? PlaceViewCell

        cell?.placeModel = self.sourceData[indexPath.row]
        return cell ?? UITableViewCell();
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaceDetailViewController") as? PlaceDetailViewController {

            self.navigationController?.pushViewController(vc, animated: true)
            vc.model = self.sourceData[indexPath.row]
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
