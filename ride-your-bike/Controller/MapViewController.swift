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
        
        //Handle the Annotation Clustering display
        if annotation is MKClusterAnnotation {
            var clusterView = map.dequeueReusableAnnotationView(withIdentifier: "cluster")
            if clusterView == nil{
                clusterView = MKAnnotationView(annotation: annotation, reuseIdentifier: "cluster")
            }
            else{
                clusterView?.annotation = annotation
            }
            let initialImage = UIImage(named: "stations")
            clusterView?.image = initialImage?.scaleImage(toSize: CGSize(width: 20, height: 20))
            return clusterView
            
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
            let initialImage = UIImage(named: "velo")
            annotationView?.image = initialImage?.scaleImage(toSize: CGSize(width: 17, height: 17))
            annotationView?.clusteringIdentifier = "station"
        }
   
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
            //renderer.fillColor = .red
            renderer.strokeColor = .systemBlue
            renderer.lineCap = .round
            renderer.lineWidth = 5
            return renderer
        }
        return MKPolylineRenderer(overlay: overlay)
    }
}
