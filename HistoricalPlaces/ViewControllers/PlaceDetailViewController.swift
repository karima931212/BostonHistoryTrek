//
//  PlaceDetailViewController.swift
//  HistoricalPlaces
//
//  Created by Jiayi Xu on 2017/2/28.
//  Copyright © 2017年 Jiayi Xu. All rights reserved.
//

import UIKit
import ImageSlideshow
import Kingfisher
import MapKit

class PlaceDetailViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var typeLabel: UILabel!

    @IBOutlet weak var coverImg: ImageSlideshow!

    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var introdutionLabel: UILabel!

    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var goBtn: UIButton!
    

    var model:PlaceModel?{
        didSet{
            fillData();
        }
    }
    func backAction(sender:UIButton){

        self.navigationController?.popViewController(animated: true);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PlaceDetailViewController.didTap))
        coverImg.addGestureRecognizer(gestureRecognizer)
        
        coverImg.backgroundColor = UIColor.white
        coverImg.slideshowInterval = 5.0
        coverImg.pageControlPosition = PageControlPosition.underScrollView
        coverImg.pageControl.currentPageIndicatorTintColor = ColorPalette.SegmentTint
        coverImg.pageControl.pageIndicatorTintColor = UIColor.lightGray
        coverImg.contentScaleMode = UIViewContentMode.scaleAspectFill
//        coverImg.currentPageChanged = { page in
//
//        }

        

        fillData();
        backBtn.addTarget(self, action: #selector(self.backAction(sender:)), for: .touchUpInside)

    }
func didTap() {
   coverImg.presentFullScreenController(from: self)
}
    func fillData(){
        if (model != nil && model!.mid != nil){

            titleLabel?.text = model?.name
            typeLabel?.text = model?.tag
            addressLabel?.text = (model?.address ?? "") + " | \(String(format:"%.3f",model!.disDouble)) miles away"
            introdutionLabel?.text = model?.descriptionField ?? "Empty"

            var array:[InputSource] = [InputSource]()
            let size  = Int(model?.photoSize ?? "0") ?? 0
            for i in 0..<size
            {
                print("https://historicalplaces.azurewebsites.net/photos/\(model!.mid!)_\(i).jpg")
              
                array.append(KingfisherSource(
                    url:URL(string: "https://historicalplaces.azurewebsites.net/photos/\(model!.mid!)_\(i).jpg")!,
                    placeholder:UIImage.init(named: "placeholder-img")!))
                
            }
            

            coverImg?.setImageInputs(array)

            if MyLocationHelper.sharedInstanced.containLoaction(model: model!){
                addBtn?.isSelected = true;
            }else{
                addBtn?.isSelected = false;
            }

        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func attionAction(_ sender: UIButton) {
        if model == nil { return }
        if(addBtn.isSelected){
            MyLocationHelper.sharedInstanced.removeLoaction(model: model!)
        }else{
            MyLocationHelper.sharedInstanced.addLoaction(model: model!)
        }
        addBtn.isSelected = !addBtn.isSelected
    }

   
    @IBAction func goAction(_ sender: Any) {
        if model == nil { return }
        
        guard let lon = Double(model!.longitude!) ,let lat = Double(model!.latitude!) else {return}
        
        
        var currentLoc = MKMapItem.forCurrentLocation()
        var toLocation = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude:lon)))
        MKMapItem.openMaps(with: [currentLoc,toLocation], launchOptions: [
            MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
            
            MKLaunchOptionsShowsTrafficKey:true
            ])
        
        
        
    }

}
