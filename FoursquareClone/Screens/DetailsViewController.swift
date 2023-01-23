//
//  DetailsViewController.swift
//  FoursquareClone
//
//  Created by Berkay YAY on 12.12.2022.
//

import UIKit
import MapKit
import Parse
class DetailsViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var detailsImageView: UIImageView!
    
    @IBOutlet weak var detailsNameLabel: UILabel!
    
    @IBOutlet weak var detailsTypeLabel: UILabel!
    
    @IBOutlet weak var detailsMapView: MKMapView!
    
    @IBOutlet weak var detailsCommentLabel: UILabel!
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromParse()
        detailsMapView.delegate = self
    }
    
    func getDataFromParse(){
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error!")
            }else{
                // OBJECTS
                if objects != nil {
                    let chosenPlaceObject = objects![0]
                    guard let placeName = chosenPlaceObject.object(forKey: "name") as? String,
                          let placeType = chosenPlaceObject.object(forKey: "type") as? String,
                          let placeComment = chosenPlaceObject.object(forKey: "comment") as? String,
                          let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String,
                          let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String,
                          let doubleLat = Double(placeLatitude),
                          let doubleLong = Double(placeLongitude),
                          let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject  else {
                        return
                    }
                    self.detailsNameLabel.text = placeName
                    self.detailsTypeLabel.text = placeType
                    self.detailsCommentLabel.text = placeComment
                    self.chosenLatitude = doubleLat
                    self.chosenLongitude = doubleLong
                    imageData.getDataInBackground { data, error in
                        if error == nil {
                            if data != nil {
                                self.detailsImageView.image = UIImage(data: data!)
                            }
                            
                        }
                    }
                    //MAPS
                    let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    let region = MKCoordinateRegion(center: location, span: span)
                    self.detailsMapView.setRegion(region, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotation.title = placeName
                    annotation.subtitle = placeType
                    self.detailsMapView.addAnnotation(annotation)
                }
            }
        }
    }
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if self.chosenLatitude != 0.0 && self.chosenLongitude != 0.0{
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                guard let placemark = placemarks else {
                    return
                }
                if placemark.count > 0 {
                    let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                    let mapItem = MKMapItem(placemark: mkPlaceMark)
                    mapItem.name = self.detailsNameLabel.text
                    let launchOpt = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                    mapItem.openInMaps(launchOptions: launchOpt)
                    
                }
            }
        }
    }

}
