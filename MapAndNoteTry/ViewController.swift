//
//  ViewController.swift
//  MapAndNoteTry
//
//  Created by Ganzorig Battur on 9/15/17.
//  Copyright © 2017 Ganzorig Battur. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var noteTitle: UILabel!
    var locationget = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let getLocation = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecognizer:)))
        getLocation.minimumPressDuration = 2
        map.addGestureRecognizer(getLocation)
        
        // get the details about location and note from note title on table
        if noteTracker == -1{
        
            locationget.delegate = self
            locationget.desiredAccuracy = kCLLocationAccuracyBest
            locationget.requestWhenInUseAuthorization()
            locationget.startUpdatingLocation()
        
        
        }else{
        
            if let place = notes[noteTracker]["place"]{
            
                let x = notes[noteTracker]["latit"]
                let y = notes[noteTracker]["longit"]
                noteText.text = notes [noteTracker]["note"]
                noteTitle.text = notes[noteTracker]["place"]
                let latitude = Double(x!)
                let longitude = Double(y!)
                let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.map.setRegion(region, animated: true)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = place
                self.map.addAnnotation(annotation)
            }
        
        }
        
    }
    @IBAction func saveNote(_ sender: Any) {
        if noteTracker != -1{
        
            notes[noteTracker]["note"] = noteText.text
         UserDefaults.standard.set(notes, forKey:"notes")
        }else{
            noteText.text = "Please go to note list and choose which note you want to edit"
        UserDefaults.standard.set(notes, forKey:"notes")
        }
        
    }
    
    func longpress(gestureRecognizer: UIGestureRecognizer){
    
        if gestureRecognizer.state == UIGestureRecognizerState.began{
        
            let thePoint = gestureRecognizer.location(in: self.map)
            let theLocation = self.map.convert(thePoint, toCoordinateFrom: self.map)
            print(theLocation)
            
            let location = CLLocation(latitude: theLocation.latitude, longitude: theLocation.longitude)
            
            var title = ""
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error != nil{
                    print(error)
                }else{
                    if let placemark = placemarks?[0]{
                        if placemark.subThoroughfare != nil {
                        
                            title += placemark.subThoroughfare! + " "
                        }
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare!
                        }
                    }
                    
                }
                if title == ""{
                    title = "Added \(NSDate())"
                }
                let annotation = MKPointAnnotation()
                annotation.coordinate = theLocation
                annotation.title = title
                self.map.addAnnotation(annotation)
                notes.append(["place":title, "note":"Write you note","latit":String(theLocation.latitude),"longit":String(theLocation.longitude)])
                UserDefaults.standard.set(notes, forKey:"notes")
                
            })
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = theLocation
            annotation.title = "Temp title"
            self.map.addAnnotation(annotation)
            
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

