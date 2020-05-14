//
//  MyLocationHelper.swift
//  HistoricalPlaces
//
//  Created by Jiayi Xu on 2017/4/22.
//  Copyright © 2017年 Jiayi Xu. All rights reserved.
//

import UIKit

class MyLocationHelper: NSObject {

    public static  let sharedInstanced = MyLocationHelper()
    private var array = [PlaceModel]()
    
    private override init(){
        super.init();
        // loading locale
        if let data = UserDefaults.standard.data(forKey: "loc") {

            if let tmp = NSKeyedUnarchiver.unarchiveObject(with: data) as? [PlaceModel]{
                array.append(contentsOf: tmp)
            }
        }
        
    }
    
    public func getArray()->[PlaceModel]{
        return array;
    }
    public func addLoaction(model:PlaceModel){
        if (self.array.contains(model)) { return }
        self.array.append(model)
        save()
    }
    
    public func removeLoaction(model:PlaceModel){
        if (!self.array.contains(model)) { return }
        self.array.remove(at: self.array.index(of: model)!);
        save()
    }
    
    public func containLoaction(model:PlaceModel)->Bool{
        return self.array.contains(model);
    }
    
    public func save(){
        let queue = DispatchQueue.global();
        queue.async {[unowned self] in
            objc_sync_enter(self)
            
            let data = NSKeyedArchiver.archivedData(withRootObject: self.array)
            UserDefaults.standard.set(data, forKey: "loc")
            objc_sync_exit(self)
        }
        
    }
}
