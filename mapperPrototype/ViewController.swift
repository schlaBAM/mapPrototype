//
//  ViewController.swift
//  mapperPrototype
//
//  Created by BAM on 2018-01-09.
//  Copyright © 2018 BAM. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    private var locationManager = CLLocationManager()
    final let regionRadius : CLLocationDistance = 1000
    
    var currentPath : [CLLocationCoordinate2D] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapAndTableView()
        checkLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory issue dog")
    }
    
    func setupMapAndTableView(){
        map.delegate = self
        map.showsUserLocation = true
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.register(CustomMapCell.self, forCellReuseIdentifier: "cell")
    }
    
    func checkLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.allowsBackgroundLocationUpdates = true
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinates = manager.location?.coordinate {
            if UIApplication.shared.applicationState == .active {
                print(coordinates)
            } else {
                print("background: \(coordinates)")
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let coordinates = userLocation.coordinate
        currentPath.append(coordinates)
        let region = MKCoordinateRegionMakeWithDistance(coordinates, regionRadius, regionRadius)
        map.setRegion(region, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Timeline"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell", for: indexPath) as! CustomMapCell
        //maybe use fancy cell with small map of path?
        return cell
    }
    
}

class CustomMapCell : UITableViewCell {
    //customizing now for further customizing in the future
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var time: UILabel!
}
