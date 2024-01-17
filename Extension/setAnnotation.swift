//
//  setAnnotation.swift
//  Kick_Going
//
//  Created by Jason Yang on 1/17/24.
//

import MapKit

extension MapViewController {
    //원하는 위도와 경도에 핀 설치
    func setAnnotation(title strTitle: String, subtitle strSubtitle: String, latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longitudeValue: longitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        kickboardMap.addAnnotation(annotation)
    }
    //원하는 위도와 경도에서 핀 설치
    func removeAnnotationsFromMap() {
        let annotations = kickboardMap.annotations
        kickboardMap.removeAnnotations(annotations)
    }
}

