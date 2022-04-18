//
//  MapViewController.swift
//  ride-your-bike
//
//  Created by Antoine Desanti on 14/04/2022.
//

import Foundation
import MapKit

extension ViewController : MKMapViewDelegate {
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
        
        switch annotation.title{
        case "A":
            annotationView?.image = UIImage(systemName: "mappin.and.ellipse")?.withTintColor(.red, renderingMode: .alwaysTemplate)
        case "B":
            annotationView?.image = UIImage(systemName: "mappin")?.withTintColor(.blue)

        default:
            let imageConfiguration = UIImage.SymbolConfiguration(scale: .medium)
            let imageConfiguration2 = UIImage.SymbolConfiguration(paletteColors: [.white, .black])
            imageConfiguration.applying(imageConfiguration2)
            let initialImage = UIImage(systemName: "bicycle.circle.fill")
            annotationView?.image = initialImage?.scaleImage(toSize: CGSize(width: 17, height: 17))
        }
   
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
            //renderer.fillColor = .red
            renderer.strokeColor = .red
            renderer.lineCap = .round
            renderer.lineWidth = 5
            return renderer
        }
        return MKPolylineRenderer(overlay: overlay)
    }
}
