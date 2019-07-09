//
//  HomePageViewController.swift
//  SCIOH
//
//  Created by Romain Boudet and Sakib Rasul on 13/02/16.
//  Copyright © 2016 Romain Boudet and Sakib Rasul. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import Alamofire
import SwiftyJSON
import Mapbox
import GeoFire

class HomePageViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate, MGLMapViewDelegate{
    var resultSearchController:UISearchController?
    var annotation:MGLAnnotation?
    var localSearchRequest:MKLocalSearch.Request?
    var localSearch:MKLocalSearch?
    var localSearchResponse:MKLocalSearch.Response?
    var error:NSError?
    let locationManager = CLLocationManager()
    let popUpBundle = Bundle(for: PopUpViewController.self)
    var pointAnnotation:CustomPointAnnotation?
    var pinAnnotationView:MKPinAnnotationView?
    var locB = CLLocation(latitude: 0.0, longitude: 0.0)
    var locA = CLLocation(latitude: 0.0, longitude: 0.0)
    var ref : DatabaseReference? = Database.database().reference()
    var idleTimer:Timer = Timer()
    var circleQuery = GFCircleQuery()
    var isMonitoringRegion = false
    var annotations = [MGLAnnotation]()
    var annotationArray = [String]()
    // The "Test" branch of the Firebase Database contains the names, logos, and coordinates
    // of every test venue. So, let's create a GeoFire instance at that branch.
    var geoFire = GeoFire.init(firebaseRef: Database.database().reference(withPath: "Test"))

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @IBOutlet var mapView: MGLMapView?
    @IBAction func showSearchBar(_ sender: AnyObject) {
        if let userSearchTable = storyboard?.instantiateViewController(withIdentifier: "UserSearchTable") as? UserSearchTable {
            resultSearchController = UISearchController(searchResultsController: userSearchTable)
            resultSearchController?.searchResultsUpdater = userSearchTable
            resultSearchController?.hidesNavigationBarDuringPresentation = true
            resultSearchController?.dimsBackgroundDuringPresentation = true
            definesPresentationContext = true
            resultSearchController?.searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            present((resultSearchController)!, animated: true, completion: nil)
        } else {
            print("Something went wrong while creating the resultSearchController.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Create a webform for adding club locations.
        
        // The following line can be used to manually add the location of test venue Apt. 200:
        // geoFire?.setLocation(CLLocation(latitude: 45.514372, longitude: -73.573364), forKey: "Apt200")
        
        mapView?.delegate = self
        updateMap()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if(CLLocationManager.locationServicesEnabled()) {
            // The user has allowed us to locate them.
            // Let's update the map and start checking whether or not they're at a venue.
            print("The user has enabled location services :)")
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.mapView?.showsUserLocation = true
            locationManager.startMonitoringSignificantLocationChanges()

            if let currentLocation = locationManager.location {
                let circleQuery = (geoFire.query(at: currentLocation, withRadius: 0.5))
                let currentCoordinate = currentLocation.coordinate
                
                mapView?.setCenter(currentCoordinate, zoomLevel: 13, animated: true)
                
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) in
                    if error == nil {
                        let currentPlace = (placemarks?[0]) as CLPlacemark?
                        if(currentPlace?.locality != "Montréal") {
                            // The user is not in Montréal.
                            let alertController = UIAlertController(title: "Location Not Supported", message: "SCIOH currently works in Montréal. Stay with us though - we're always working on expanding!", preferredStyle: UIAlertController.Style.alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        } else {
                            print("The user is in Montréal. Proceed.")
                        }
                    } else {
                        print(error as Any)
                    }
                })
                
                _ = circleQuery.observe(.keyEntered, with: { (key, location) in
                    print("The user is currently near venue \(key). Start monitoring.")
                    let region = CLCircularRegion.init(center: (location.coordinate), radius: 50.0, identifier: key)
                    self.locationManager.startMonitoring(for: region)
                    self.isMonitoringRegion = true
                    print("Started monitoring \(region.identifier).")
                })
                
                _ = circleQuery.observe(.keyExited, with: { (key, location) in
                    print("Key \(key) exited the search area")
                    let region = CLCircularRegion.init(center: (location.coordinate), radius: 50.0, identifier: key)
                    self.locationManager.stopMonitoring(for: region)
                    self.isMonitoringRegion = false
                })
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
//        // To increase performance,
//        // this loop ensures that only a certain number of venues
//        // are shown on the map at the same time.
//        while(self.annotations.count > 20) {
//            if let oldestAnnotation = self.annotations.first {
//                mapView.removeAnnotation(oldestAnnotation)
//                self.annotations.remove(at: 0)
//            }
//        }
        updateMap()
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        
        
        print("The user tapped on \(String(describing: annotation.title))'s annotation!")
        
        mapView.deselectAnnotation(annotation, animated: true)
        
//         TODO: Show venue attendees in annotation.
//         Though annotation.title should be the name of a venue in the database,
//         searching for it in the database may not yield results because
//         the name of a venue's node in the database does not contain spaces or periods.
//         Thus we search instead for venueID, which is annotation.title sans " " and ".".
//        let venueID = annotation.title??.replacingOccurrences(of: "[ .]", with: "", options: [.regularExpression])
//        self.ref?.child("Test/\(String(describing: venueID))/attendees").observe(DataEventType.value, with: ({ (snapshot) in
//          for child in snapshot.children.allObjects as! [DataSnapshot] {
//              print("User \(child.key) is currently going HARD at \(String(describing: annotation.title)).")
//              TODO: Relay the above information to the user.
//          }
//        }))
        
        
        let popUpViewController = PopUpViewController(nibName: "PopUpView", bundle: popUpBundle)
        if let annotationTitle = annotation.title {
            popUpViewController.showInView(aView: self.view, withTitle: annotationTitle, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogOutButtonTapped(_ sender: AnyObject) {
        try! Auth.auth().signOut()
        UserDefaults.standard.setValue(nil, forKey: "uid")
        if let LoginPage = self.storyboard?.instantiateViewController(withIdentifier: "Login") as? LoginPageViewController {
            let LoginPageNav = UINavigationController(rootViewController: LoginPage)
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController = LoginPageNav
            }
        }
    }
    
    
    func updateMap() {
        self.ref?.child("Test").observe(DataEventType.value, with: ({ (snapshot) in
            // Iterate through every venue in the database and create an annotation for each one.
            // Then add each annotation to the map.
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let childDict = child.value as! [String : AnyObject]
                let annotation = MGLPointAnnotation()
                if((childDict["name"]) != nil) {
                    let venueName = childDict["name"] as! String
                    annotation.title = venueName
                }
                if((childDict["logo"]) != nil) {
                    let venueLogo = childDict["logo"] as! String
                    annotation.subtitle = venueLogo
                }
                if((childDict["l"]) != nil) {
                    let coordArray = childDict["l"] as! [Double]
                    let venueCoordinate = CLLocationCoordinate2DMake(coordArray[0], coordArray[1])
                    annotation.coordinate = venueCoordinate
                }
                if(annotation.title != nil && (childDict["l"]) != nil && annotation.subtitle != nil) {
                    let coordArray = childDict["l"] as! [Double]
                    let venueCoordinate = CLLocationCoordinate2DMake(coordArray[0], coordArray[1])
                    print("checking if annotation coordinate (\(venueCoordinate.longitude),\(venueCoordinate.latitude)) is in map view...")
//                    let venueMapPoint = MKMapPoint(venueCoordinate)
                    let rect = MKMapRect(x: self.mapView?.visibleCoordinateBounds.sw.longitude ?? 0.0, y: self.mapView?.visibleCoordinateBounds.ne.latitude ?? 0.0, width: (self.mapView?.visibleCoordinateBounds.ne.longitude ?? 0.0) - (self.mapView?.visibleCoordinateBounds.sw.longitude ?? 0.0) , height: (self.mapView?.visibleCoordinateBounds.sw.latitude ?? 0.0) - (self.mapView?.visibleCoordinateBounds.ne.latitude ?? 0.0))
                    print("the user is viewing a map where minX = \(rect.minX), maxX = \(rect.maxX), minY = \(rect.minY), maxY = \(rect.maxY)")
                    if(
                        (rect.maxX - venueCoordinate.longitude) <= (rect.maxX - rect.minX)
                        &&
                        (rect.minY - venueCoordinate.latitude) <= (rect.minY - rect.maxY)
                        ){
                        print("annotation map point is within view")
                        if(!self.annotationArray.contains(annotation.title ?? "ZZZZZZZ")){
                            self.annotationArray.append(annotation.title ?? "YYYYYYYY")
                            self.mapView?.addAnnotation(annotation)
                            print("an annotation was added for \(annotation.title as Optional) at  (\(annotation.coordinate.longitude), \(annotation.coordinate.latitude))")
                        } else {
                            print("annotion already exists on map, do not add")
                        }
                    } else {
                        print("annotation map point is not in view")
                    }
                }
            }
        }))
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "\(annotation.coordinate.latitude)")
        
        if annotationImage == nil {
            let url = URL(string: "https://images.weserv.nl/?url=\(annotation.subtitle!!)&h=60&w=60&t=square")
            
            let data:Data?
            do {
                data = try Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                let image = UIImage(data: data!)!
                annotationImage = MGLAnnotationImage(image: maskRoundedImage(image: image, radius: 30.0) , reuseIdentifier: "\(annotation.coordinate.latitude)")
            } catch {
                print("An image could not be found at URL \(annotation.subtitle as Optional) for \(annotation.title as Optional).")
            }
        }
        
        return annotationImage
    }
    
//    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "\(annotation.coordinate.latitude)")
//        
//        if annotationView == nil {
//            let url = URL(string: "https://images.weserv.nl/?url=\(annotation.subtitle!!)&h=300&w=300&t=square")
//            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//            let image = UIImage(data: data!)!
//            annotationView?.addSubview(UIImageView(image: maskRoundedImage(image: image, radius: 150 )))
//        }
//        
//        return annotationView
//    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return false
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        print("the user has moved a bit.")
        
        circleQuery.center = locationManager.location!
        
//        locationManager.requestState(for: CLCircularRegion(center: CLLocationCoordinate2D(latitude: 45.514372, longitude: -73.573364), radius: 50.0, identifier: "apt200"))
        
//        if(idleTimer.isValid) {
//            idleTimer.invalidate()
//            print("user has moved a bit. time to start timing...")
//            idleTimer = Timer()
//        }
//        
//        idleTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.userIsIdle), userInfo: nil, repeats: false);
        
    }
    
//    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
//        print("the user is in venue \(region.identifier) with state \(state)")
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func userIsIdle() {
        print("the user hasn't moved much. time to find out where the user is.")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("the user just entered venue \(region.identifier)")
        
        if(idleTimer.isValid) {
            if(String(describing: idleTimer.userInfo) != "") {
                print("Not resetting the timer because the user has entered an extraneous venue.")
            } else {
                print("The user has entered a venue. Resetting idle timer.")
                idleTimer.invalidate()
                idleTimer = Timer()
            }
        } else {
            print("time to start timing for \(region.identifier)...")
            
            idleTimer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(userIsIdle(_:)), userInfo: region.identifier, repeats: false);
        }

        if(idleTimer.userInfo == nil) {
            print("time to start timing for \(region.identifier)...")
        
            idleTimer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(userIsIdle(_:)), userInfo: region.identifier, repeats: false);
        }

        
        // TODO: Check if the user is within the region's polygon as described in Firebase.
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("the user just exited venue \(region.identifier)")
        
        if(region.identifier.contains(".") != true) {
            self.ref?.child("users/\(UserDefaults.standard.value(forKey: "uid") as! String)/location").setValue("none")
            self.ref?.child("Test/\(region.identifier)/attendees/\(UserDefaults.standard.value(forKey: "uid") as! String)").setValue(nil)
        }
            
        if(idleTimer.isValid) {
            if(String(describing: idleTimer.userInfo) == region.identifier) {
                print("The user has left. Resetting idle timer.")
                idleTimer.invalidate()
                idleTimer = Timer()
            } else {
                print("Not stopping the timer because the user has exited an extraneous venue.")
            }
        }
    }
    
    @objc func userIsIdle(_ timer: Timer) {
        let idleVenue = timer.userInfo as! String
        print("the user has been at venue \(idleVenue) for a little while.")
        self.ref?.child("users/\(UserDefaults.standard.value(forKey: "uid") as! String)/location").setValue(idleVenue)
        self.ref?.child("Test/\(idleVenue)/attendees/\(UserDefaults.standard.value(forKey: "uid") as! String)").setValue("true")
    }
    
    func maskRoundedImage(image: UIImage, radius: Float) -> UIImage {
        let imageView: UIImageView = UIImageView(image: image)
        var layer: CALayer = CALayer()
        layer = imageView.layer
        
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(radius)
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage!
    }

}





extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
    /// Note that the new image size is not rectSize, but within it.
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        
        let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
    
}


