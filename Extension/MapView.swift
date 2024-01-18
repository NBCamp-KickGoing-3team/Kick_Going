//
//  MapView.swift
//  Kick_Going
//
//  Created by Jason Yang on 1/16/24.
//

import MapKit

// 지도의 annotation을 didSelect 때 selectedKickboardID으로 프로퍼티가 전송되는 매서드
extension MapViewController {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotaion = view.annotation else {
            return
        }
        _ = annotaion.coordinate.latitude
        _ = annotaion.coordinate.longitude
        
        if let title = annotaion.title, let selectedKicboard = kickboardItems.first(where: {$0.title == title}) {
            self.selectedKickboardID = selectedKicboard.id
        } else {
            print("선택한 킥보드를 찾을 수 없습니다.")
        }
    }
}
