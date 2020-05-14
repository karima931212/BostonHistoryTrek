//
//  CallOutView.swift
//  HistoricalPlaces
//
//  Created by Jiayi Xu on 2017/3/12.
//  Copyright © 2017年 Jiayi Xu. All rights reserved.
//

import UIKit
import Mapbox

class CallOutView: UIView,MGLCalloutView {

    var representedObject: MGLAnnotation

    // Lazy initialization of optional vars for protocols causes segmentation fault: 11s in Swift 3.0. https://bugs.swift.org/browse/SR-1825

    var leftAccessoryView = UIView() /* unused */
    var rightAccessoryView = UIView() /* unused */



    weak var delegate: MGLCalloutViewDelegate?
    weak var mDelegate: MGLCalloutViewDelegate?

    let tipHeight: CGFloat = 10.0
    let tipWidth: CGFloat = 20.0


    @IBOutlet weak var tagIcon: UIImageView!
    @IBOutlet weak var tagDes: UILabel!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        super.init(frame: .zero)
        addAction()
    }

    required init?(coder decoder: NSCoder) {
        self.representedObject = PlaceAnnotation();
        super.init(coder:decoder )
        addAction()


    }

    func addAction(){
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.calloutTapped)));
    }

    // MARK: - MGLCalloutView API
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {

        if (representedObject is PlaceAnnotation){
            
            let annotation = representedObject as! PlaceAnnotation
            if let model = annotation.placeModel {
                //填写数据
                switch model.tag ?? "" {
                case PlaceTag.Museum.rawValue:
                    tagIcon.image = UIImage(named: "Museum")
                    tagDes.text = "Museum";
                case PlaceTag.Park.rawValue:
                    tagIcon.image = UIImage(named: "Park")
                    tagDes.text = "Park";
                case PlaceTag.Historic.rawValue:
                    tagIcon.image = UIImage(named: "Historic")
                    tagDes.text = "Historic";
                case PlaceTag.Stadium.rawValue:
                    tagIcon.image = UIImage(named: "Stadium")
                    tagDes.text = "Stadium";
                default:
                    tagIcon.image = UIImage(named: "Other")
                    tagDes.text = "General";
                }
            }

            placeName.text = representedObject.title ?? ""
            distanceLabel.text = representedObject.subtitle ?? ""


            let frameWidth:CGFloat = self.systemLayoutSizeFitting(CGSize(width: UIScreen.main.bounds.width-50, height: 95)).width
            let frameHeight:CGFloat = 95.0
            let frameOriginX = rect.origin.x + rect.width/2 - frameWidth/2
            let frameOriginY = rect.origin.y - frameHeight + rect.size.height/2
            frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)

            view.addSubview(self)
        }


        if animated {
            alpha = 0

            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.alpha = 1
            }
        }
    }

    func dismissCallout(animated: Bool) {
        if (superview != nil) {
            if animated {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.alpha = 0
                    }, completion: { [weak self] _ in
                        self?.removeFromSuperview()
                })
            } else {
                removeFromSuperview()
            }
        }
    }

    // MARK: - Callout interaction handlers

    func isCalloutTappable() -> Bool {
        
//        if let delegate = delegate {
//            if delegate.responds(to: #selector(MGLCalloutViewDelegate.calloutViewShouldHighlight)) {
//                return delegate.calloutViewShouldHighlight!(self)
//            }
//        }
        return true
    }

    func calloutTapped() {
        if isCalloutTappable() && mDelegate?.responds(to: #selector(MGLCalloutViewDelegate.calloutViewTapped)) ?? false {
            dismissCallout(animated: true)
            mDelegate?.calloutViewTapped!(self)
        }
    }



}
