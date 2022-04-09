//
//  ViewController.swift
//  ride-your-bike
//
//  Created by Antoine Desanti on 09/04/2022.
//

import UIKit
import MapKit
import CoreLocation


extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}


class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var selectCityButton: UIButton!
    
    let map = MKMapView()
    let nantesCoordinate = CLLocationCoordinate2D(
        latitude: 47.2151496951626, longitude: -1.55022624256337
    )
    let marseilleCoordinate = CLLocationCoordinate2D(
        latitude: 43.290716834278136, longitude: 5.359258014511654
    )
    var stations: [Station] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(map)
        view.addSubview(selectCityButton)
        map.frame = view.bounds
        map.delegate = self
        map.bringSubviewToFront(selectCityButton)
        
        Task{
            do{
                var fetchedStations = try await fetchStations()
                updateStations(fetchedStations: fetchedStations)
                initSelectCityButton()
                
                if !stations.isEmpty {
                    
                    let currentStation = stations[6]
                    for station in stations {
                        let stationCoordinate = CLLocationCoordinate2D(latitude: (station.position?.latitude)!,
                                                                       longitude: (station.position?.longitude)!)
                        
                        addStationCustomPin(location: stationCoordinate, station: station)
                    }

                    map.setRegion(MKCoordinateRegion(
                        center: CLLocationCoordinate2D(
                            latitude: (currentStation.position?.latitude)!,
                            longitude: (currentStation.position?.longitude)!
                        ), span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)), animated: false)
                }
            }
        }
        
        print(stations)
     
        
        keyboardHandler()
    }
    
    func initSelectCityButton(){
        let optionClosure = { [self](action: UIAction) in
            let city = cities.filter { $0.name == action.title }[0]
            
            map.setRegion(MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: city.latitude,
                    longitude: city.longitude
                ), span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)), animated: true)
           
            print(action.title)}
        
        selectCityButton.menu = UIMenu(children: [
            UIAction(title: "Nantes", state: .on, handler: optionClosure),
            UIAction(title: "Marseille", state: .on, handler: optionClosure),
            UIAction(title: "Toulouse", state: .on, handler: optionClosure)
        ])
//        for station in stations {
//            selectCityButton.
//        }
            
}
    
    func updateStations(fetchedStations: [Station]){
        stations = fetchedStations
    }
    
    
    func keyboardHandler(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    
    private func addStationCustomPin(location: CLLocationCoordinate2D, station: Station){
        let pin = MKPointAnnotation()
        pin.coordinate = location
        pin.title = "Station : " + station.name!
        pin.subtitle = "Available bikes : " + String(station.available_bikes!)
        map.addAnnotation(pin)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
        }
        else{
            annotationView?.annotation = annotation
        }
        
        let initialImage = UIImage(named: "bicycle")
        
        annotationView?.image = initialImage?.scaleImage(toSize: CGSize(width: 20, height: 20))
        return annotationView
    }
    
    struct Position: Codable{
        let latitute: Float
        let longitude: Float
    }
    
    


}

