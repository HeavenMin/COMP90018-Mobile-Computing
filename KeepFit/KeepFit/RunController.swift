//
//  RunController.swift
//  KeepFit
//
//  Created by Lang LIN on 05/10/2017.
//  Copyright © 2017 Min Gao. All rights reserved.
//

import UIKit
import MapKit

class RunController: UIViewController,MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var tap1: UIButton!
    @IBOutlet weak var tap2: UIButton!
    var route = Array<MKPolyline>()
    
    
    
    
    // help functions to set the radius showed in the map
    let regionRadius: CLLocationDistance = 500
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.text = String("00:00:00")
        centerMapOnLocation(location: CLLocation(latitude:locationManager.location!.coordinate.latitude,longitude:locationManager.location!.coordinate.longitude))
        
        
        //enable image button
        tap1.setBackgroundImage(UIImage(named:"start_green"), for: .normal)
        tap2.setBackgroundImage(UIImage(named:"stop_red"), for: .normal)
        tap1.isEnabled = true
        tap2.isEnabled = false
        
        
        
        //pre set artworks show on the map
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
    
    
    
    
    // below part belongs to MKMapViewDelegate part
    func mapView(_ mapView: MKMapView!, viewFor annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? Artwork {
            
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                //                // 3
                //                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                //                view.canShowCallout = true
                //                view.calloutOffset = CGPoint(x: -5, y: 5)
                //                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
                //                view.pinColor = annotation.pinColor()
                var imageView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                imageView.canShowCallout = true
                imageView.calloutOffset = CGPoint(x: -5, y: 5)
                imageView.centerOffset = CGPoint(x:0,y:-30)
                imageView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
                imageView.image = annotation.iconImage
                return imageView
            }
            return view
        }
        return nil
    }
    
    var drawingMap = false
    
    var lastRoute : MKPolyline!
    
    var firstTime = true
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork
        
        let sourceLocation = locationManager.location!.coordinate
        let destinationLocation = location.location()
        drawingMap = false
        drawPath(sourceLocation: sourceLocation,destinationLocation: destinationLocation)
        
        //        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        //        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    
    func drawPath(sourceLocation:CLLocationCoordinate2D, destinationLocation:CLLocationCoordinate2D){
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        //
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        
        //
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // direction caculation
        let directions = MKDirections(request: directionRequest)
        
        //
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            if(self.firstTime){
                self.firstTime = false
            }
            else{
                self.mapView.remove(self.lastRoute)
            }
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            self.lastRoute = route.polyline
            if (!self.drawingMap){
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        if (!self.drawingMap){
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 4.0
        }
        else{
            renderer.strokeColor = UIColor.red
            renderer.lineWidth = 2.0
        }
        return renderer
    }
    
    
    
    
    
    
    //this part is for timer
    
    
    
    var counter :Int = 0
    var timer = Timer()
    //0 means finished/not started,1 means started,2 means paused
    var isPlaying = 0
    var startPoint : CLLocationCoordinate2D!
    var countStartPoint : CLLocationCoordinate2D!
    var endPoint : CLLocationCoordinate2D!
    var distance = 0.0
    
    
    @IBAction func startAndResume(_ sender: Any) {
        if(isPlaying == 0) {
            tap1.isEnabled = false
            tap2.isEnabled = true
            tap1.setBackgroundImage(UIImage(named:"start_green"), for: .normal)
            tap2.setBackgroundImage(UIImage(named:"pause_orange"), for: .normal)
            isPlaying = 1
            startPoint = locationManager.location!.coordinate
            countStartPoint = startPoint
            var resetRegion = MKCoordinateRegionMakeWithDistance(startPoint,300,300)
            mapView.setRegion(resetRegion, animated: true)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        }
        else{
            if (isPlaying == 1){
                return
            }
            else{
                tap1.isEnabled = false
                tap2.isEnabled = true
                isPlaying = 1
                countStartPoint = locationManager.location!.coordinate
                tap1.setBackgroundImage(UIImage(named:"start_green"), for: .normal)
                tap2.setBackgroundImage(UIImage(named:"pause_orange"), for: .normal)
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
            }
        }
    }
    
    
    @IBAction func pauseAndReset(_ sender: Any) {
        if(isPlaying == 0) {
            return
        }
        else{
            if (isPlaying == 1){
                tap1.isEnabled = true
                tap2.isEnabled = true
                timer.invalidate()
                isPlaying = 2
                
                tap1.setBackgroundImage(UIImage(named:"start_green"), for: .normal)
                tap2.setBackgroundImage(UIImage(named:"stop_red"), for: .normal)
            }
            else{
                tap1.isEnabled = true
                tap2.isEnabled = false
                timer.invalidate()
                isPlaying = 0
                counter = 0
                timeLabel.text = String("00:00:00")
                tap1.setBackgroundImage(UIImage(named:"start_green"), for: .normal)
                tap2.setBackgroundImage(UIImage(named:"stop_red"), for: .normal)
                
                if distance > 50 {
                    let azureOperator = AzureOperation()
                    azureOperator.insertDistanceRecord(distance: distance)
                }
                self.mapView.removeOverlays(route)
                route.removeAll()
                distance = 0.0
            }
        }
    }
    
    
    //update time counter and distance every second
    @objc func UpdateTimer() {
        counter = counter + 1
        let hour = counter / 3600
        let minute = (counter % 3600)/60
        let second = counter % 60
        timeLabel.text = String(format: "%02d:%02d:%02d",hour,minute,second)
        endPoint = locationManager.location!.coordinate
        
        drawingMap = true
        
        let locations = [CLLocation(latitude:countStartPoint.latitude,longitude:countStartPoint.longitude), CLLocation(latitude : endPoint.latitude,longitude : endPoint.longitude)]
        var coordinates = locations.map({(location: CLLocation!) -> CLLocationCoordinate2D in return location.coordinate})
        let polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
        self.mapView.add(polyline, level: MKOverlayLevel.aboveRoads)
        route.append(polyline)
        let startPointCoordinate = CLLocation(latitude:countStartPoint.latitude,longitude: countStartPoint.longitude)
        let endPointCoordinate = CLLocation(latitude:endPoint.latitude,longitude: endPoint.longitude)
        distance = distance + startPointCoordinate.distance(from: endPointCoordinate)
        distanceLabel.text = String(format:"%.2f meters",distance)
        countStartPoint = endPoint
    }
    
    
}

