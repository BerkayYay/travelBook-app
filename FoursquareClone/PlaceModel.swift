//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Berkay YAY on 13.12.2022.
//

import Foundation
import UIKit
class PlaceModel {
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeComment = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    
    private init() {}
    
}
