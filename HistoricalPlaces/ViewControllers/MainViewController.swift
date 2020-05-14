//
//  MainViewController.swift
//  HistoricalPlaces
//
//  Created by Jiayi Xu on 2017/2/28.
//  Copyright © 2017年 Jiayi Xu. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import SwiftLocation
import AlamofireObjectMapper
import DropDown
import SVProgressHUD

class MainViewController: UIViewController {


    @IBOutlet weak var topView: UIView!

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var segment: UISegmentedControl!

    @IBOutlet weak var filterBtn: UIButton!

    weak var mapVC: MapViewController!

    weak var listVc:PlaceListViewController!

    public var sourceData:[PlaceModel]?

    let chooseDropDown = DropDown()

    var selectedTag = PlaceTag.All
    @IBOutlet weak var numberLabel: UILabel!

    var userLocation:CLLocationCoordinate2D!

   
    override func viewDidLoad() {
        super.viewDidLoad()

        initViewType();
        bindChildController();
        selectedAction(segment);
        //startUpdateLocation();

    }

    func initViewType(){

        //topView.backgroundColor = ColorPalette.Purple;
        SVProgressHUD.setDefaultMaskType(.clear)
        segment.setTitleTextAttributes([ NSForegroundColorAttributeName : UIColor.white ], for: .normal)
        segment.setTitleTextAttributes([ NSForegroundColorAttributeName : UIColor.white ], for: .selected)
        segment.layer.cornerRadius = segment.bounds.height / 2
        segment.layer.borderColor = UIColor.white.cgColor
        segment.layer.borderWidth = 2
        segment.layer.masksToBounds = true
       // filterBtn.setTitleColor(UIColor.blue, for: .normal)
        filterBtn.addTarget(self, action: #selector(self.filterAction), for: .touchUpInside)


        getLastLocation()
        setNumberLabelText(number: 0)
        setupChooseDropDown()
    }

    func getLastLocation(){

        userLocation = CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "lat"), longitude: UserDefaults.standard.double(forKey: "lng"))

    }

    func filterAction(){

        chooseDropDown.show()

    }

    func setNumberLabelText(number:Int){
        numberLabel.text = "Browse \(number) historical locations near you"
    }

    func setupChooseDropDown() {
        
        chooseDropDown.anchorView = filterBtn

        chooseDropDown.width = UIScreen.main.bounds.width/3*2;
        // By default, the dropdown will have its origin on the top left corner of its anchor view
        // So it will come over the anchor view and hide it completely
        // If you want to have the dropdown underneath your anchor view, you can do this:
        chooseDropDown.bottomOffset = CGPoint(x: 0, y: filterBtn.bounds.height)

        // The list of items to display. Can be changed dynamically
        chooseDropDown.dataSource = ["All", "General", "Museums" , "Parks" , "Stadium"]

        /*** IMPORTANT PART FOR CUSTOM CELLS ***/
        chooseDropDown.cellNib = UINib(nibName: "TagDropDownCell", bundle: nil)

        chooseDropDown.selectRow(at: 0)

        // Action triggered on selection
        chooseDropDown.selectionAction = { [unowned self] (index, item) in
            //reload
            switch item {
            case "General":
                self.selectedTag = PlaceTag.General
            case "Museums":
                self.selectedTag = PlaceTag.Museum
            case "Parks":
                self.selectedTag = PlaceTag.Park
            case "Stadium":
                self.selectedTag = PlaceTag.Stadium
            default:
                self.selectedTag = PlaceTag.All
            }

            self.reloadMapAndList(location: self.userLocation)

        }
    }


    func bindChildController(){

        for vc in self.childViewControllers{
            if (vc is MapViewController){
                mapVC = vc as! MapViewController
                mapVC.main = self
            }else if (vc is PlaceListViewController){
                listVc = vc as! PlaceListViewController
            }
        }
    }


    @IBAction func selectedAction(_ sender: UISegmentedControl!) {

        let value = sender.selectedSegmentIndex;

        mapVC.view.superview?.isHidden = value == 1;
        listVc.view.superview?.isHidden = value == 0;

    }


    var shouldAlert = true;
    var isFirst = true;
    func startUpdateLocation(){

        let request = Location.getLocation(accuracy: .house, frequency: .continuous, success: {[weak self] (request, location) -> (Void) in
            guard let `self` = self else { return }
            self.userLocation = location.coordinate
            UserDefaults.standard.set(location.coordinate.latitude, forKey: "lat")
            UserDefaults.standard.set(location.coordinate.longitude, forKey: "lng")
            if self.isFirst {
                self.mapVC.updateCenter(location.coordinate)
                self.resultsFromServer(location.coordinate);
                self.isFirst = false;
            }

        }) {[weak self] (request, location, error) -> (Void) in
            guard let `self` = self else { return }

            if let locationError = error as? LocationError {
                switch locationError{
                case LocationError.authorizationDenided:
                    if self.shouldAlert != true { return;}
                    let alert = UIAlertController(title: "Denided", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.shouldAlert = false;
                    break
                default:
                    if self.shouldAlert != true {return;}
                    let alert = UIAlertController(title: "Failed", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.shouldAlert = false;
                    break;
                }
            }
        }

        request.register(observer: LocObserver.onAuthDidChange(.main, {[weak self] (request, oldAuth, newAuth) in
            guard let `self` = self else { return }
            if (oldAuth != .authorizedAlways || oldAuth != .authorizedWhenInUse) && (newAuth == .authorizedAlways || newAuth == .authorizedWhenInUse)  {

                self.shouldAlert = true;
            }

        }))

        request.minimumDistance = 100

    }
    
    
    public func resultsFromServer( _  location:CLLocationCoordinate2D?) {

        //        simulateData(location:location)
        //        return ;
        SVProgressHUD.show(withStatus: "loading...")
        var location = location
        if (location == nil && self.userLocation != nil)
        {
            location = self.userLocation!
        }
        let northBound = mapVC.mapView.visibleCoordinateBounds.ne.latitude
        let eastBound = mapVC.mapView.visibleCoordinateBounds.ne.longitude
        let southBound = mapVC.mapView.visibleCoordinateBounds.sw.latitude
        let westBound = mapVC.mapView.visibleCoordinateBounds.sw.longitude

        let parameters: Parameters = [
            "uuid": UIDevice.current.identifierForVendor!.uuidString,
            "lng": location?.longitude ?? 0.0,
            "lat":location?.latitude ?? 0.0,
            "northBound": northBound,
            "eastBound": eastBound,
            "southBound": southBound,
            "westBound": westBound,
            "tag":"all",
            "secret":APIHelper.genSecret(uuid: UIDevice.current.identifierForVendor!.uuidString)]
        print(parameters)
        let manager = Alamofire.SessionManager.default;
        manager.session.configuration.timeoutIntervalForRequest = 10
        print("reached pre")
        let url = URL(string: APIHelper.getPlaceList)
        
        manager.request(url!, method: .post, parameters: parameters).responseArray { [weak self](response:DataResponse<[PlaceModel]>) in
            SVProgressHUD.dismiss()
            guard let `self` = self else { return }
             print("response string: " + (String(data: response.data!, encoding: .utf8) ?? "error"))
            guard let placeResponse = response.result.value , placeResponse.count > 0 else {
                return;
            }
            
            self.sourceData = placeResponse;
            self.reloadMapAndList(location: self.userLocation)
            
        }

    }
    
    

    func reloadMapAndList(location:CLLocationCoordinate2D){

        let arr = self.sourceData?.filter({ [weak self] (element) -> Bool in
            guard let `self` = self else { return true}
            switch self.selectedTag
            {
            case .All:
                return true
            default:
                return element.tag == self.selectedTag.rawValue
            }
        })
        setNumberLabelText(number: arr?.count ?? 0)
        //filter
        mapVC.reloadMap(placeModels:arr ,currentLocation: location);

        listVc.reloadList(sourceData: arr);
    }


    

    
}
