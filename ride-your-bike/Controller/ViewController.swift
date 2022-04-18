//
//  ViewController.swift
//  ride-your-bike
//
//  Created by Antoine Desanti on 09/04/2022.
//

import UIKit
import MapKit
import CoreLocation



class ViewController: UIViewController {

    @IBOutlet weak var selectCityButton: UIButton!
    @IBOutlet weak var initSeachScreenButton: UIButton!
    @IBOutlet weak var stationsToggleButton: UIButton!
    
    
    let map = MKMapView()
    var startPin: MKPointAnnotation = MKPointAnnotation()
    var endPin: MKPointAnnotation = MKPointAnnotation()
    var stations: [Station] = []
    var toggleBlurBackground = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.addSubview(map)
        view.addSubview(selectCityButton)
        view.addSubview(initSeachScreenButton)
      //  view.addSubview(stationsToggleButton)
        
        stationsToggleButton.layer.cornerRadius = stationsToggleButton.frame.width / 2
        stationsToggleButton.layer.masksToBounds = true
        
    
        
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
                            latitude: (cities[0].latitude),
                            longitude: (cities[0].longitude)
                        ), span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)), animated: false)
                }
            }
        }
        
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
            UIAction(title: "Marseille", state: .on, handler: optionClosure),
            UIAction(title: "Nantes", state: .on, handler: optionClosure),
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
    
    func toggleBlur(){
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
    

    func computeRoute(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D){
        
        if(startPoint.latitude != 0 && endPoint.latitude != 0){
            map.setCenter(
                CLLocationCoordinate2D(
                    latitude: (startPoint.latitude+endPoint.latitude)/2,
                    longitude: (startPoint.longitude+endPoint.longitude)/2), animated: true)
            
            map.region.span =  MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        }
        
        self.map.removeAnnotation(startPin)
        self.map.removeAnnotation(endPin)

        startPin = MKPointAnnotation()
        startPin.coordinate = startPoint
        startPin.title = "A"
        
        endPin = MKPointAnnotation()
        endPin.coordinate = endPoint
        endPin.title = "B"
        
        
        map.addAnnotation(startPin)
        map.addAnnotation(endPin)
        
        let routeRequest = MKDirections.Request()
        routeRequest.source =  MKMapItem(placemark: MKPlacemark(coordinate: startPoint))
        routeRequest.destination =  MKMapItem(placemark: MKPlacemark(coordinate: endPoint))
        routeRequest.transportType = .walking
        
        let directions = MKDirections(request: routeRequest)
        directions.calculate{ response, error in
            guard let route = response?.routes.first else {return}
            print("ROUTE: ",route.polyline)
            self.map.removeOverlays(self.map.overlays)
           
            self.map.addOverlay(route.polyline)
            self.map.setVisibleMapRect(
                route.polyline.boundingMapRect,
                animated: true)
            print("Overlay added !")
        }
        
    }
    
    func subSearchMethod(startPointString: String, endPointString: String){
        
        var searchArea = MKCoordinateRegion()
        searchArea.center = map.centerCoordinate
        
        let searchRequest = MKLocalSearch.Request()
        let searchRequest2 = MKLocalSearch.Request()
        searchRequest.region = searchArea
        searchRequest2.region = searchArea
        searchRequest.naturalLanguageQuery = startPointString
        searchRequest2.naturalLanguageQuery = endPointString

        let search = MKLocalSearch(request: searchRequest)
        let search2 = MKLocalSearch(request: searchRequest2)

        var startPoint = CLLocationCoordinate2D();
        var endPoint = CLLocationCoordinate2D();
        
        search.start { response1, error in
            guard let response1 = response1 else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            startPoint = response1.mapItems[0].placemark.coordinate
            
            search2.start { response2, error in
               guard let response2 = response2 else {
                   print("Error: \(error?.localizedDescription ?? "Unknown error").")
                   return
               }
               endPoint = response2.mapItems[0].placemark.coordinate
               self.computeRoute(startPoint: startPoint, endPoint: endPoint)
           }
        }
    }
    

    
}


    

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



