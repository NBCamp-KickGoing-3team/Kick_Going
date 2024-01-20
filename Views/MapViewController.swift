//
//  MapViewController.swift
//  Kick_Going
//
//  Created by Jason Yang on 1/15/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    // MARK: - 델리게이트 프로토콜
    weak var registrationDelegate: RegistrationDelegate?
    
    // MARK: - UI Properties
    
    @IBOutlet weak var kickGoingMap: MKMapView!
    @IBOutlet weak var buttonBarrow: UIButton!
    @IBOutlet weak var buttonKickboard: UIButton!
    @IBOutlet weak var buttonBicycle: UIButton!
    @IBOutlet weak var currentLocation: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    var dataSource: [RideData] = []
    var kickboardItems: [RideData] = [
        RideData(id: 0, title: "킥보드1", subtitle: "대여가능", latitude: 37.5665, longitude: 126.9774),
        RideData(id: 1, title: "킥보드2", subtitle: "대여 중", latitude: 37.5660, longitude: 126.9805),
        RideData(id: 2, title: "킥보드3", subtitle: "대여가능", latitude: 37.5640, longitude: 126.9791),
        RideData(id: 3, title: "킥보드4", subtitle: "대여가능", latitude: 37.5658, longitude: 126.9818),
        RideData(id: 4, title: "킥보드5", subtitle: "대여 중", latitude: 37.5647, longitude: 126.9768),
    ]
    var bicycleItems: [RideData] = [
        RideData(id: 0, title: "자전거1", subtitle: "대여가능", latitude: 37.5665, longitude: 126.9770),
        RideData(id: 1, title: "자전거2", subtitle: "대여가능", latitude: 37.5662, longitude: 126.9801),
        RideData(id: 2, title: "자전거3", subtitle: "대여가능", latitude: 37.5643, longitude: 126.9793),
        RideData(id: 3, title: "자전거4", subtitle: "대여가능", latitude: 37.5655, longitude: 126.9815),
        RideData(id: 4, title: "자전거5", subtitle: "대여가능", latitude: 37.5642, longitude: 126.9763),
    ]
    
    let locationManager = CLLocationManager()
    
    var selectedKickboardID: Int?
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        kickGoingMap.showsUserLocation = true
        kickGoingMap.delegate = self
    }
    
    // MARK: - Methods
    // 파라미터 : 위도, 경도, 범위로 원하는 위치 표시
    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span : Double) -> CLLocationCoordinate2D {
        let toGoLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let toGoRegion = MKCoordinateRegion(center: toGoLocation, span: spanValue)
        kickGoingMap.setRegion(toGoRegion, animated: true)
        
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
        print("현재위치 버튼이 탭 되었습니다.")
    }
    
    @IBAction func tappedButtonBorrow(_ sender: UIButton) {
        
        guard let selectedID = selectedKickboardID else {
            alertButton(in: self, title: "선택된 킥보드가 없습니다." , messgae: "대여를 원하신다면 '예'를 눌러주세요.")
            return
        }
        
        if let kickboardToBorrow = kickboardItems.first(where: {$0.id == selectedID}) {
            if kickboardToBorrow.subtitle == "대여가능" {
                print("대여하기가 신청 되었습니다.")
                //alertButton(in: self, title: "대여하시겠습니까?", messgae: "대여를 원하신다면 '예'를 눌러주세요.")
                showMyViewControllerInACustomizedSheet()
            } else {
                alertButton(in: self, title: "이미 대여 중인 킥보드입니다.", messgae: "대여를 원하신다면 '예'를 눌러주세요.")
                
            }
        }
    }
    
    @IBAction func tappedButtonKickboard(_ sender: UIButton) {
        print("킥보드 표시 버튼이 탭 되었습니다.")
        
        removeAnnotationsFromMap()
        
        kickboardItems += KickboardManager.shared.kickboardItems
        let dataSource = kickboardItems
        for kickboard in dataSource {
            setAnnotation(title: kickboard.title, subtitle: kickboard.subtitle, latitudeValue: kickboard.latitude, longitudeValue: kickboard.longitude, delta: 0.01)
        }
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func tappedButtonBicycle(_ sender: UIButton) {
        print("자전거 표시 버튼이 클릭되었습니다.")
        
        removeAnnotationsFromMap()
        
        let dataSource = bicycleItems
        for bicycle in dataSource {
            setAnnotation(title: bicycle.title, subtitle: bicycle.subtitle, latitudeValue: bicycle.latitude, longitudeValue: bicycle.longitude, delta: 0.01)
        }
        locationManager.stopUpdatingLocation()
    }
}
