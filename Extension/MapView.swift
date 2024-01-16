//
//  MapView.swift
//  Kick_Going
//
//  Created by Jason Yang on 1/16/24.
//

import MapKit

// 지도를 클릭했을 때 호출되는 매서드 
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotaion = view.annotation else {
            return
        }
        let latitude = annotaion.coordinate.latitude
        let longitude = annotaion.coordinate.longitude
        
        let alertController = UIAlertController(title: "위치 정보", message: "선택한 위치의 좌표는 (\(latitude), \(longitude))입니다.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
