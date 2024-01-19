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
    
    enum RentalItemType {
        case kickboard(RideData)
        case bicycle(RideData)
        case none
    }
    
    var selectedKickboardID: Int?
    var selectedBicycleID: Int?
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
        // 지도의 중심 좌표와 줌 레벨 설정
        let center = CLLocationCoordinate2D(latitude: 37.565534, longitude: 126.977895) // 서울 시청
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        kickGoingMap.setRegion(region, animated: true)
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
        if let myKickboardID = selectedKickboardID, let kickboardToBorrow = kickboardItems.first(where: { $0.id == selectedKickboardID }) {
            if kickboardToBorrow.subtitle == "대여가능" {
                print("킥보드 대여하기가 신청되었습니다.")
                DispatchQueue.main.async {
                    self.buttonKickboard.backgroundColor = .green
                    self.buttonBicycle.backgroundColor = .white
                }
            } else {
                alertButton(in: self, title: "이미 대여 중인 킥보드입니다.", messgae: "대여를 원하신다면 '네'를 눌러주세요.")
            }
        } else if let myBicylceID = selectedBicycleID, let bicycleToBorrow = bicycleItems.first(where: {$0.id == selectedBicycleID}) {
            if bicycleToBorrow.subtitle == "대여가능" {
                print("자전거 대여하기가 신청되었습니다.")
                DispatchQueue.main.async {
                    self.buttonBicycle.backgroundColor = .green
                    self.buttonKickboard.backgroundColor = .white
                }
            } else {
                alertButton(in: self, title: "이미 대여 중인 자전거입니다.", messgae: "대여를 원하신다면 '네'를 눌러주세요.")
            }
        } else {
            let notSelectedMessage = "선택된 킥보드 또는 자전거가 없습니다."
            alertButton(in: self, title: notSelectedMessage, messgae: "대여를 원하신다면 '네'를 눌러주세요.")
        }
    }
    
    @IBAction func tappedButtonKickboard(_ sender: UIButton) {
        print("킥보드 표시 버튼이 탭 되었습니다.")
        
        removeAnnotationsFromMap()
        
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
