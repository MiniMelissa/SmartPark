//
//  MapViewController.swift
//  Smartpark
//
//  Created by Timothy Redband on 4/20/17.
//  Copyright © 2017 Timothy Redband. All rights reserved.
//

import Foundation
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let initialLocation = CLLocation(latitude: 42.089292, longitude: -75.969619) //Binghamton university
    let regionRadius: CLLocationDistance = 600
    var eta_service = ETAService()

    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation(location: initialLocation)
        
        mapView.delegate = self
        mapView.showsBuildings = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        //mapView.mapType = .hybrid
        
   
        
        eta_service.setup(completionHandler: { Void in
            addSmartBusAnnotations()
            addSmartStopAnnotations()
        })
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0,regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addSmartBusAnnotations(){
        let cs_shuttles = eta_service.get_campus_shuttle_buses()
        mapView.addAnnotations(cs_shuttles)
    }
    
    func addSmartStopAnnotations(){
        guard let cs_stops = eta_service.eta_get_campus_shuttle_stops() else {
            print("Error getting campus shuttle stop annotations")
            return
        }
        mapView.addAnnotations(cs_stops)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? SmartBus {
            return get_annotation_view_helper(annotation: annotation, type: "bus", icon_size: annotation.icon_size)
        } else if let annotation = annotation as? SmartStop {
            return get_annotation_view_helper(annotation: annotation, type: "stop", icon_size: annotation.icon_size)
        }
        return nil
    }
    
    func get_annotation_view_helper(annotation: MKAnnotation, type: String, icon_size: Double) -> MKAnnotationView {
        var icon_image: UIImage?
        if type == "bus" {
            icon_image = UIImage(named: (annotation as! SmartBus).imageName)
        } else {
            icon_image = UIImage(named: (annotation as! SmartStop).imageName)
        }
        let id = type
        var view: MKAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: id) {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: id)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        }
        view.image = icon_image
        view.frame.size.height = CGFloat(icon_size)
        view.frame.size.width = CGFloat(icon_size)
        return view
    }
    
    
    /*
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
*/

    
    
    
    
    
    
}
