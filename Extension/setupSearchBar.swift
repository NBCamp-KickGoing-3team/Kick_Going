//
//  setupSearchBar.swift
//  Kick_Going
//
//  Created by Jason Yang on 1/18/24.
//
import UIKit
import MapKit

// setupSearchBar 구현 매소드
extension MapViewController: UISearchBarDelegate {
    func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "위치 검색"
        navigationItem.titleView = searchBar
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        if let searchText = searchBar.text, !searchText.isEmpty {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(searchText) {
                (placemark, error) in
                if let error = error {
                    print("위치 검색 에러: \(error.localizedDescription)")
                    return
                }
                if let firstPlacemark = placemark?.first,
                   let location = firstPlacemark.location {
                    let latitude = location.coordinate.latitude
                    let longitude = location.coordinate.longitude

                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    annotation.title = firstPlacemark.name
                    annotation.subtitle = firstPlacemark.locality

                    self.kickGoingMap.addAnnotation(annotation)
                    //self.goLocation(latitudeValue: latitude, longitudeValue: longitude, delta: 0.01)
                } else {
                    print("장소를 찾을 수 없음")
                }
            }
        }
    }
}
