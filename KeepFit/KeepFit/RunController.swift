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
    
    var mapView : MKMapView!
    
    let initialLocation = CLLocation(latitude: -37.814251, longitude: 144.963169)
    
    // help functions to set the radius showed in the map
    let regionRadius: CLLocationDistance = 2000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //initializaion of th map
    func initMap() -> Void {
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.addSubview(mapView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMap()
        centerMapOnLocation(location: initialLocation)
        
        
        let artwork1 = Artwork(title: "Royal Park",
                              locationName: "Royal Park",
                              discipline: "Park",
                              coordinate: CLLocationCoordinate2D(latitude: -37.7874401836, longitude: 144.950696197))
        let artwork2 = Artwork(title: "Lincoln Square",
                               locationName: "Lincoln Square",
                               discipline: "Park",
                               coordinate: CLLocationCoordinate2D(latitude: -37.80199, longitude: 144.96234))
        let artwork3 = Artwork(title: "Argyle Square",
                               locationName: "Argyle Square",
                               discipline: "Park",
                               coordinate: CLLocationCoordinate2D(latitude: -37.80257, longitude: 144.96651))
        let artwork4 = Artwork(title: "Carlton Garden",
                               locationName: "Melbourne Museum",
                               discipline: "Garden",
                               coordinate: CLLocationCoordinate2D(latitude: -37.80280, longitude: 144.96942))
        let artwork5 = Artwork(title: "Alexandra Gardens",
                               locationName: "Alexandra Gardens",
                               discipline: "Garden",
                               coordinate: CLLocationCoordinate2D(latitude: -37.72415, longitude: 144.73879))
        let artwork6 = Artwork(title: "University Square",
                               locationName: "University Square",
                               discipline: "Park",
                               coordinate: CLLocationCoordinate2D(latitude: -37.801499, longitude: 144.960226))
        
        
        mapView.delegate = self
        mapView.addAnnotation(artwork)
        mapView.addAnnotation(artwork1)
        mapView.addAnnotation(artwork2)
        mapView.addAnnotation(artwork3)
        mapView.addAnnotation(artwork4)
        mapView.addAnnotation(artwork5)
        
        
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
