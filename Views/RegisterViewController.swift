//
//  RegisterViewController.swift
//  Kick_Going
//
//  Created by Jason Yang on 1/15/24.
//

import UIKit
class RegisterViewController: UIViewController {
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("킥보드 등록", for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(registerButton)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        registerButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        registerButton.center = view.center
        registerButton.layer.cornerRadius = 10
    }
    
//    @objc private func registerButtonTapped() {
//        showRegisterAlert()
//    }
    
    private func showRegisterAlert() {
        let alertController = UIAlertController(title: "킥보드 등록", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "킥보드 이름"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "킥보드 번호"
            textField.keyboardType = .numberPad
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "위도"
            textField.keyboardType = .decimalPad
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "경도"
            textField.keyboardType = .decimalPad
        }
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let name = alertController.textFields?[0].text,
               let number = alertController.textFields?[1].text,
               let latitudeChan = alertController.textFields?[2].text,
               let longitudeChan = alertController.textFields?[3].text,
               let latitude = Double(latitudeChan),
               let longitude = Double(longitudeChan) {
                self.handleRegistration(name: name, number: number, latitude: latitude, longitude: longitude)
            } else {
                self.showValidationErrorAlert()
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func handleRegistration(name: String, number: String, latitude: Double, longitude: Double) {
        // 입력된 데이터를 바탕으로 킥보드 위치 생성 함수
        // MapViewController에 킥보드 정보를 전달하고 지도에 마커를 추가하는 기능 등
    }
    
    // 잘못된 입력값 처리 Alert
    private func showValidationErrorAlert() {
        let alert = UIAlertController(title: "입력 오류", message: "올바른 값을 입력해주세요.", preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(confirmButton)
        present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
