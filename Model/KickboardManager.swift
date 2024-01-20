//
//  KickboardManager.swift
//  Kick_Going
//
//  Created by t2023-m0041 on 1/20/24.
//

import Foundation
import MapKit

class KickboardManager {
    static let shared = KickboardManager()

    private init() {}

    var kickboardItems: [RideData] = []

    func registerKickboard(name: String, number: String, latitude: Double, longitude: Double) {
        let newKickboard = RideData(id: kickboardItems.count, title: name, subtitle: "대여가능", latitude: latitude, longitude: longitude)
        kickboardItems.append(newKickboard)
    }
}

