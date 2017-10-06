//
//  RunController.swift
//  KeepFit
//
//  Created by Lang LIN on 05/10/2017.
//  Copyright © 2017 Min Gao. All rights reserved.
//

import UIKit
import MapKit

class RunController: UIViewController{
    @IBOutlet weak var mapView: MKMapView!
    
    let initialLocation = CLLocation(latitude: -37.814251, longitude: 144.963169)
    
    // help functions to set the radius showed in the map
    let regionRadius: CLLocationDistance = 2000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerMapOnLocation(location: initialLocation)
        
        
        let artwork1 = Artwork(title: "Royal Park",
                              locationName: "Royal Park",
                              discipline: "Park",
                              coordinate: CLLocationCoordinate2D(latitude: -37.791109, longitude: 144.950984))
        let artwork2 = Artwork(title: "Lincoln Square",
                               locationName: "Lincoln Square",
                               discipline: "Square",
                               coordinate: CLLocationCoordinate2D(latitude: -37.802411, longitude: 144.962851))
        let artwork3 = Artwork(title: "Argyle Square",
                               locationName: "Argyle Square",
                               discipline: "Square",
                               coordinate: CLLocationCoordinate2D(latitude: -37.802729, longitude: 144.965783))
        let artwork4 = Artwork(title: "Carlton Garden",
                               locationName: "Melbourne Museum",
                               discipline: "Garden",
                               coordinate: CLLocationCoordinate2D(latitude: -37.806252, longitude: 144.971147))
        let artwork5 = Artwork(title: "Alexandra Gardens",
                               locationName: "Alexandra Gardens",
                               discipline: "Garden",
                               coordinate: CLLocationCoordinate2D(latitude: -37.820764, longitude: 144.972260))
        let artwork6 = Artwork(title: "University Square",
                               locationName: "University Square",
                               discipline: "Square",
                               coordinate: CLLocationCoordinate2D(latitude: -37.801499, longitude: 144.960226))
        let artwork7 = Artwork(title: "Birrarung Marr",
                               locationName: "Birrarung Marr",
                               discipline: "Park",
                               coordinate: CLLocationCoordinate2D(latitude: -37.818169, longitude: 144.973210))
        let artwork8 = Artwork(title: "Dockland",
                               locationName: "DockLand",
                               discipline: "Area",
                               coordinate: CLLocationCoordinate2D(latitude: -37.816434, longitude: 144.947652))
        let artwork9 = Artwork(title: "Dockland Park",
                               locationName: "Dockland Park",
                               discipline: "Park",
                               coordinate: CLLocationCoordinate2D(latitude: -37.820600, longitude: 144.946620))
        let artwork10 = Artwork(title: "Melbourne University Oval",
                               locationName: "Melbourne University Oval",
                               discipline: "Oval",
                               coordinate: CLLocationCoordinate2D(latitude: -37.794723, longitude: 144.961541))
        
        mapView.delegate = self
        mapView.addAnnotation(artwork1)
        mapView.addAnnotation(artwork2)
        mapView.addAnnotation(artwork3)
        mapView.addAnnotation(artwork4)
        mapView.addAnnotation(artwork5)
        mapView.addAnnotation(artwork6)
        mapView.addAnnotation(artwork7)
        mapView.addAnnotation(artwork8)
        mapView.addAnnotation(artwork9)
        mapView.addAnnotation(artwork10)
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
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

extension RunController: MKMapViewDelegate {
    
    // 1
    func mapView(_ mapView: MKMapView!, viewFor annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? Artwork {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
                view.pinColor = annotation.pinColor()
            }
            return view
        }
        return nil
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}
