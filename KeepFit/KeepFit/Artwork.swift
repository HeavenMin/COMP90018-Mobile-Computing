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
        iconImage = UIImage(named:"garden_location")
        switch discipline {
        case "Park","Garden":
            iconImage = UIImage(named:"garden_location")
            break
        default:
            iconImage = UIImage(named:"park_3")
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
    func location() -> CLLocationCoordinate2D {
        return coordinate
    }
    
    func setNewIcon(){
        switch discipline {
        case "Park","Garden":
            iconImage = UIImage(named:"garden_location")
            break
        default:
            iconImage = UIImage(named:"park_3")
            break
        }
    }
}
