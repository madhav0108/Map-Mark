//
//  ViewController.swift
//  Map Mark
//
//  Created by madhav sharma on 7/17/20.
//  Copyright © 2020 madhav sharma. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecognizer:)))
        
        uilpgr.minimumPressDuration = 2
        
        map.addGestureRecognizer(uilpgr)
        
        if activeMark == -1 {
            
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
        } else {
            
            if marks.count > activeMark {
                
                if let name = marks[activeMark]["name"] {
                    
                    if let lat = marks[activeMark]["lat"] {
                        
                        if let lon = marks[activeMark]["lon"] {
                            
                            if let lattitude = Double(lat) {
                                
                                if let longitude = Double(lon) {
                                    
                                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                    
                                    let coordinate = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
                                    
                                    let region = MKCoordinateRegion(center: coordinate, span: span)
                                    
                                    self.map.setRegion(region, animated: true)
                                    
                                    let annotation = MKPointAnnotation()
                                    
                                    annotation.coordinate = coordinate
                                    
                                    annotation.title = name
                                    
                                    self.map.addAnnotation(annotation)
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        // Do any additional setup after loading the view.
    }

    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
    
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
    
            let touchPoint = gestureRecognizer.location(in: self.map)
    
            let newCoordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
        
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
        
            var title = ""
        
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            
                if error != nil {
                
                    print(error!)
                
                } else {
                
                    if let placemark = placemarks?[0] {
                    
                        if placemark.subThoroughfare != nil {
                        
                            title += placemark.subThoroughfare! + " "
                        
                        }
                    
                        if placemark.thoroughfare != nil {
                        
                            title += placemark.thoroughfare!
                        
                        }
                    
                    }
                
                }
            
                if title == "" {
                
                    title = "Added \(NSDate())"
                
                }
            
                let annotation = MKPointAnnotation()
            
                annotation.coordinate = newCoordinate
            
                annotation.title = title
            
                self.map.addAnnotation(annotation)
            
                marks.append(["name":title, "lat":String(newCoordinate.latitude), "lon":String(newCoordinate.longitude)])
                
                UserDefaults.standard.set(marks, forKey: "marks")
            
            })
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.map.setRegion(region, animated: true)
    }
    
}

