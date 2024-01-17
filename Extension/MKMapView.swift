//
//  MKMapView.swift
//  Kick_Going
//
//  Created by Jason Yang on 1/17/24.
//

import MapKit

extension MapViewController {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 사용자의 위치 표시는 변경하지 않습니다.
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "Kickboard"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        // 킥보드 이미지로 설정
        annotationView?.image = UIImage(named: "kickboard")
        
        let size = CGSize(width: 35, height: 35)
        annotationView?.frame = CGRect(origin: annotationView?.frame.origin ?? CGPoint.zero, size: size)
        
        return annotationView
    }
}





/*
 func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
 let identifier = "kickboard.jpg"
 var annotaionView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
 
 if annotaionView == nil {
 annotaionView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
 annotaionView!.canShowCallout = true
 } else {
 annotaionView!.annotation = annotation
 }
 return annotaionView
 }
 */
