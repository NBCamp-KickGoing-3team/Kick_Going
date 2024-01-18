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
        kickGoingMap.addAnnotation(annotation)
    }
    func removeAnnotationsFromMap() {
        let annotations = kickGoingMap.annotations
        kickGoingMap.removeAnnotations(annotations)
    }
}
