//
//  DataStore.swift
//  Kick_Going
//
//  Created by 김가빈 on 1/19/24.
//

import Foundation

class DataStore {
    static let shared = DataStore()

    private(set) var kickboards: [RegisteredKickboard] = []

    private init() {}

    func saveKickboard(kickboard: RegisteredKickboard) {
        kickboards.append(kickboard)
    }

    func getKickboards() -> [RegisteredKickboard] {
        return kickboards
    }
}
