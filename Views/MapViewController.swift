//
//  MapViewController.swift
//  Kick_Going
//
//  Created by Jason Yang on 1/15/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: - UI Properties
    
    @IBOutlet weak var kickboardMap: MKMapView!
    @IBOutlet weak var buttonBarrow: UIButton!
    @IBOutlet weak var buttonKickboard: UIButton!
    @IBOutlet weak var buttonBicycle: UIButton!
    @IBOutlet weak var currentLocation: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    var dataSource: [KickboardData] = []
    var KickboardItems: [KickboardData] = [
        KickboardData(id: 0, title: "킥보드1", subtitle: "대여가능", latitude: 37.5665, longitude: 126.9774),
        KickboardData(id: 1, title: "킥보드2", subtitle: "대여가능", latitude: 37.5660, longitude: 126.9805),
        KickboardData(id: 2, title: "킥보드3", subtitle: "대여가능", latitude: 37.5640, longitude: 126.9791),
        KickboardData(id: 3, title: "킥보드4", subtitle: "대여가능", latitude: 37.5658, longitude: 126.9818),
        KickboardData(id: 4, title: "킥보드5", subtitle: "대여가능", latitude: 37.5647, longitude: 126.9768),
    ]
    let locationManager = CLLocationManager()
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        kickboardMap.showsUserLocation = true
        
        kickboardMap.delegate = self
        //        searchBar.delegate = self

    }
    
    // MARK: - Methods
    // 파라미터 : 위도, 경도, 범위로 원하는 위치 표시
    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span : Double) -> CLLocationCoordinate2D {
        let toGoLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let toGoRegion = MKCoordinateRegion(center: toGoLocation, span: spanValue)
        kickboardMap.setRegion(toGoRegion, animated: true)
        
        return toGoLocation // CLLocationCoordinate2DMake(latitudeValue, longitudeValue)을 호출
    }
    
    //locations.last 마지막 지점의 위,경도를 100배로 확대해서 표시
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let goToLocation = locations.last
        //toGoLocation의 정보를 받아 위도, 경도, 범위를 주입
        _ = goLocation(latitudeValue: (goToLocation?.coordinate.latitude)!, longitudeValue: (goToLocation?.coordinate.longitude)!, delta: 0.01)
        
        CLGeocoder().reverseGeocodeLocation(goToLocation!, completionHandler: {
            (placemarks, error) -> Void in
            let pm = placemarks!.first
            let country = pm!.country
            var address:String = country!
            if pm!.locality != nil {
                address += " "
                address += pm!.locality!
            }
            if pm!.thoroughfare != nil {
                address += " "
                address += pm!.thoroughfare!
            }
            print(address)
        })
        locationManager.stopUpdatingLocation()
    }
    // MARK: - Action Methods
    
    @IBAction func tappedCurrentLocation(_ sender: Any) {
        //CLLocationManager() xcode에서 제공하는 위치매니저 매소드에서 startUpdatingLocation을 실행
        locationManager.startUpdatingLocation()
        print("현재위치 버튼이 클릭되었습니다.")
    }
    
    @IBAction func tappedButtonBorrow(_ sender: UIButton) {
        print("대여하기 버튼이 클릭되었습니다.")
    }
    
    @IBAction func tappedButtonKickboard(_ sender: UIButton) {
        print("킥보드 표시 버튼이 클릭되었습니다.")
        let dataSource = KickboardItems
        for kickboard in dataSource {
            setAnnotation(title: kickboard.title, subtitle: kickboard.subtitle, latitudeValue: kickboard.latitude, longitudeValue: kickboard.longitude, delta: 0.01)
        }
    }
    
    @IBAction func tappedButtonBicycle(_ sender: UIButton) {
        print("자전거 표시 버튼이 클릭되었습니다.")
    }
    
    // MARK: - Navigation
    
}

// 검색 기능 추가 구현 예정
//extension MapViewController: UISearchBarDelegate {
//    func setupSearchBar() {
//        let searchBar = UISearchBar()
//        searchBar.delegate = self
//        searchBar.placeholder = "위치 검색"
//        navigationItem.titleView = searchBar
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//
//        if let searchText = searchBar.text, !searchText.isEmpty {
//            let geocoder = CLGeocoder()
//            geocoder.geocodeAddressString(searchText) {
//                (placemark, error) in
//                if let error = error {
//                    print("위치 검색 에러: \(error.localizedDescription)")
//                    return
//                }
//                if let firstPlacemark = placemark?.first,
//                   let location = firstPlacemark.location {
//                    let latitude = location.coordinate.latitude
//                    let longitude = location.coordinate.longitude
//
//                    let annotation = MKPointAnnotation()
//                    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//                    annotation.title = firstPlacemark.name
//                    annotation.subtitle = firstPlacemark.locality
//
//                    self.kickboardMap.addAnnotation(annotation)
//                    self.goLocation(latitudeValue: latitude, longitudeValue: longitude, delta: 0.01)
//                } else {
//                    print("장소를 찾을 수 없음")
//                }
//            }
//        }
//    }
//}
