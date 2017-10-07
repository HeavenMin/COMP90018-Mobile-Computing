//
//  Artwork.swift
//  KeepFit
//
//  Created by Lang LIN on 05/10/2017.
//  Copyright © 2017 Min Gao. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import AddressBook

class Artwork: NSObject ,MKAnnotation {
    public var title: String?
    
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    var iconImage: UIImage?
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        iconImage = UIImage(named:"park_1")
        switch discipline {
        case "Park":
            iconImage = UIImage(named:"park_1")
            break
        case "Garden":
            iconImage = UIImage(named:"park_3")
            break
        default:
            iconImage = UIImage(named:"park_origin")
            break
        }
        super.init()
    }
    
    public var subtitle: String? {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    func pinColor() -> MKPinAnnotationColor  {
        switch discipline {
        case "Park":
            return .red
        case "Garden":
            return .purple
        default:
            return .green
        }
    }
    func location() -> CLLocationCoordinate2D {
        return coordinate
    }
    
    func setNewIcon(){
        switch discipline {
        case "Park":
            iconImage = UIImage(named:"park_1")
            break
        case "Garden":
            iconImage = UIImage(named:"park_3")
            break
        default:
            iconImage = UIImage(named:"park_origin")
            break
        }
    }
}
