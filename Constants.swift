//
//  Constants.swift
//  Kick_Going
//
//  Created by t2023-m0024 on 1/16/24.
//

import Foundation

struct Constants {
    struct Alert {
        static let title = "알림"
        static let buttonTitle = "확인"
        static let cancelTitle = "취소"
    }

    struct Join {
        static let title = "회원가입"
        static let message = "ID(이메일)와 비밀번호(8~16자의 영문 대소문자, 숫자, 특수문자)를 설정하세요"
        static let emailPlaceholder = "ID(이메일)"
        static let passwordPlaceholder = "비밀번호"
        static let passwordPlaceholder2 = "비밀번호 확인"
        static let buttonTitle = "회원가입"
    }

    struct Login {
        static let title = "로그인"
        static let message = "ID(이메일)과 비밀번호를 입력하세요"
        static let emailPlaceholder = "ID(이메일)"
        static let passwordPlaceholder = "비밀번호"
        static let buttonTitle = "로그인"
    }
    struct Error {
        static let title = "입력하신"
        static let loginFailed = "로그인에 실패했습니다. 다시 시도해주세요."
        static let invalidEmail = "유효한 이메일 형식이 아닙니다"
        static let invalidPassword = "비밀번호 형식이 올바르지 않습니다"
        static let emailAlreadyRegistered = "이미 가입되어 있는 ID입니다"
        static let mismatchedPasswords = "비밀번호가 일치하지 않습니다"
        static let emptyPassword = "비밀번호를 입력해야 가입할 수 있습니다"
        static let unknownError = "알 수 없는 오류가 발생했습니다"
        static let emailNotREgistered = "이메일은 등록된 ID(email)이 아닙니다. 회원가입을 진행해주세요"
    }
    
}
