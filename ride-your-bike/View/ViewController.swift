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
    @IBOutlet weak var initSeachScreenButton: UIButton!
    
    
    let map = MKMapView()
    var stations: [Station] = []
    var toggleBlurBackground = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(map)
        view.addSubview(selectCityButton)
        view.addSubview(initSeachScreenButton)
        
        initSeachScreenButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)



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
    
    @objc fileprivate func buttonTapped(){
        toggleBlur()
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
        
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        let imageConfiguration2 = UIImage.SymbolConfiguration(paletteColors: [.white, .black])
        imageConfiguration.applying(imageConfiguration2)

        let initialImage = UIImage(systemName: "bicycle.circle.fill")
        
        annotationView?.image = initialImage?.scaleImage(toSize: CGSize(width: 17, height: 17))
        return annotationView
    }
    
    func toggleBlur(){
        print(toggleBlurBackground)
        if toggleBlurBackground{
            view.viewWithTag(100)?.removeFromSuperview()
        } else{
            let blurEffect = UIBlurEffect(style: .regular)
            let visualEffectView = UIVisualEffectView(effect: blurEffect)
            visualEffectView.tag = 100
            visualEffectView.frame = view.bounds
            view.addSubview(visualEffectView)
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "search_view") as! SearchViewController
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: false)

        }
       
        toggleBlurBackground = !toggleBlurBackground
        
    }
    
    func closeSearchView(){
        toggleBlur()
    }
    
}

