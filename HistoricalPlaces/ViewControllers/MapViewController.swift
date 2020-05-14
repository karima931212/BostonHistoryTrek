//
//  MapViewController.swift
//  HistoricalPlaces
//
//  Created by Jiayi Xu on 2/8/17.
//  Copyright © 2017 Jiayi Xu. All rights reserved.
//

import UIKit
import Foundation
import Mapbox
import DropDown
import SVProgressHUD
import AlamofireObjectMapper
import Alamofire


class MapViewController: UIViewController, MGLMapViewDelegate,MGLCalloutViewDelegate, CLLocationManagerDelegate {
    

    
    @IBOutlet var mapView: MGLMapView!

    public weak var main:MainViewController!

    var sourceData:[PlaceModel]!;

    public func updateCenter(_ center:CLLocationCoordinate2D){
        mapView.centerCoordinate = center;
    }

    public func reloadMap(placeModels:[PlaceModel]?, currentLocation:CLLocationCoordinate2D){

        if let arr = mapView.annotations {
            mapView.removeAnnotations(arr);
        }

        //mapView.setCenter(currentLocation, zoomLevel: 17, animated: false)

        //add New
        if let models = placeModels {
            sourceData = models
            for m in sourceData{
                guard let latitude = m.latitude as? NSString , let longitude = m.longitude as? NSString else { continue;}
                let coor = CLLocationCoordinate2D(latitude:latitude.doubleValue , longitude: longitude.doubleValue)
                let annotation = PlaceAnnotation(coordinate: coor, title: m.name, subtitle:"\(String(format:"%.3f",m.disDouble)) miles away" ,sourceModel:m )

                mapView.addAnnotation(annotation)
            }

        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.showsUserLocation = true
        mapView.zoomLevel = 16
        mapView.delegate = self
        mapView.tintColor = ColorPalette.Purple
        mapView.styleURL = NSURL(string: "mapbox://styles/rykenney/cizqdkkhc001b2rp2ircadij0") as URL!
        mapView.isZoomEnabled = true;
        mapView.isScrollEnabled = true;
        mapView.isUserInteractionEnabled = true;
        mapView.userTrackingMode = .follow

    }

    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // Try to reuse the existing ‘pisa’ annotation image, if it exists.
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "location")
   
        if annotationImage == nil {
            
            var image = UIImage(named: "placeholder")!
            image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/4, right: 0))
            
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "location")
  //          annotationImage.centerOffset = CGPointMake(0, -image.size.height / 2);
        }
        
        return annotationImage
    }
    


    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {

        return !((annotation.coordinate.latitude == mapView.userLocation?.coordinate.latitude ?? 0) && (annotation.coordinate.longitude == mapView.userLocation?.coordinate.longitude ?? 0))
    }
   
    func mapView(_ mapView: MGLMapView,leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "Historic"), for: UIControlState())
        return button
    }


    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> UIView? {


        if let view = Bundle.main.loadNibNamed("CallOutView", owner: nil, options: nil)?[0]as? CallOutView{
            view.representedObject = annotation;
            view.mDelegate = self
            return view;
        }
        return nil
    }


    func calloutViewTapped(_ calloutView: UIView) {

        if let clView = calloutView as? CallOutView , let placeAnnotation = clView.representedObject as? PlaceAnnotation {

             mapView.deselectAnnotation(placeAnnotation, animated: false)

            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaceDetailViewController") as? PlaceDetailViewController {

                self.navigationController?.pushViewController(vc, animated: true)
                vc.model = placeAnnotation.placeModel
            }


        }

    }

    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {


        mapView.deselectAnnotation(annotation, animated: false)

        guard let placeAnnotation = annotation as? PlaceAnnotation else {return }


        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaceDetailViewController") as? PlaceDetailViewController {

            self.navigationController?.pushViewController(vc, animated: true)
            vc.model = placeAnnotation.placeModel
        }

    }

    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        main?.resultsFromServer(mapView.userLocation?.coordinate)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
}
