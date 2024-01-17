//
//  MemberStore.swift
//  Kick_Going
//
//  Created by t2023-m0024 on 1/16/24.
//

import Foundation

class MemberStore {
    
    // MARK: - Properties
    
    static let shared = MemberStore()
    private var members: [Member] = []
    private var currentLoggedInMember: Member?

    private init() {}
    
    private let memberInfoKey = "memberInfo"
    
    // MARK: - Public Methods
    
    //김가빈 수정 시작
    func setCurrentLoggedInMember(_ member: Member) {
            self.currentLoggedInMember = member
        }
    //김가빈 수정 끝
    
    func isEmailRegistered(_ email: String) -> Bool {
        return members.contains { $0.email == email }
    }

    func saveMemberInfo(_ member: Member) throws {
        let encodedMember = try encode(member)
        UserDefaults.standard.set(encodedMember, forKey: memberInfoKey)
    }

    func loadMemberInfo() throws -> Member? {
        guard let savedMemberData = UserDefaults.standard.data(forKey: memberInfoKey) else {
            return nil
        }

        return try decode(Member.self, from: savedMemberData)
    }
 
    func removeMemberInfo() {
        UserDefaults.standard.removeObject(forKey: memberInfoKey)
    }

    func logout() {
        currentLoggedInMember = nil
    }

    func getCurrentLoggedInMember() -> Member? {
        return currentLoggedInMember
    }
    
    func login(member: Member) {
        currentLoggedInMember = member
    }

    
    // MARK: - Private Methods
    
    private func encode<T: Encodable>(_ value: T) throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(value)
    }

    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
}
