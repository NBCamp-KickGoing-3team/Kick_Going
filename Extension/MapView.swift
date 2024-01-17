//
//  MapView.swift
//  Kick_Going
//
//  Created by Jason Yang on 1/16/24.
//

import MapKit

// 지도의 annotation을 클릭했을 때 호출되는 매서드
extension MapViewController {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotaion = view.annotation else {
            return
        }
        let latitude = annotaion.coordinate.latitude
        let longitude = annotaion.coordinate.longitude
        
        let alertController = UIAlertController(title: "킥보드 대여하기", message: "선택한 위치의 좌표는 (\(latitude), \(longitude))입니다.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "대여하기", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "취소하기", style: .destructive)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
