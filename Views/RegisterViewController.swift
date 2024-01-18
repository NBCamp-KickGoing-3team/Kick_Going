
// MARK: - 델리게이트 프로토콜 (데이터 전달용)

protocol RegistrationDelegate: AnyObject {
    func didRegisterKickboard(name: String, number: String, latitude: Double, longitude: Double)
}

import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - 델리게이트 프로토콜 (데이터 전달용)
    weak var registrationDelegate: RegistrationDelegate?
    
    private lazy var registerButton: UIButton = {
        
        // MARK: - UI Properties
        
        let button = UIButton()
        
        button.setTitle("킥보드 등록", for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 200),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        // Do any additional setup after loading the view.
    }
    
    // MARK: - @objc
    
    @objc private func registerButtonTapped() {
        showRegisterAlert()
    }
    
    // MARK: - Alert Presentaion
    
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
    
    // MARK: - 데이터 전달시 델리게이트 호출
    
    private func handleRegistration(name: String, number: String, latitude: Double, longitude: Double) {
        // 데이터를 저장하는 코드
        let newKickboard = RegisteredKickboard(name: name, number: number)
        DataStore.shared.saveKickboard(kickboard: newKickboard)
        // 델리게이트를 통해 MyPageViewController에 데이터 전달
        registrationDelegate?.didRegisterKickboard(name: name, number: number, latitude: latitude, longitude: longitude)
        // 탭 바 컨트롤러에서 MyPageViewController 탭으로 전환
        if let tabBarController = self.tabBarController {
            DispatchQueue.main.async {
                tabBarController.selectedIndex = 4
            }
        }
    }
    
    private func showValidationErrorAlert() {
        let alert = UIAlertController(title: "입력 오류", message: "올바른 값을 입력해주세요.", preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(confirmButton)
        present(alert, animated: true, completion: nil)
    }
    
}
