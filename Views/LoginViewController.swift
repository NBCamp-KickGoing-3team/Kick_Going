//
//  LoginViewController.swift
//  Kick_Going
//
//  Created by Jason Yang on 1/15/24.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - UI Properties
    
    var loginButton: UIButton!
    var joinButton: UIButton!
    var sloganLabel: UILabel!
    var emailTextField: UITextField?
    var passwordTextField: UITextField?

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupSloganLabel()
    }
    
    // MARK: - @objc
    
    @objc func loginButtonTapped() {
        presentLoginAlert()
    }
    
    @objc func joinButtonTapped() {
        presentJoinAlert()
    }
    
    // MARK: - Alert Presentation
    
    func presentLoginAlert() {
        let alertController = UIAlertController(
            title: Constants.Login.title,
            message: Constants.Login.message,
            preferredStyle: .alert
        )
        
        alertController.view.tintColor = UIColor.purple
        
        alertController.addTextField { textField in
            textField.placeholder = Constants.Join.emailPlaceholder
            self.emailTextField = textField
        }
        
        alertController.addTextField { textField in
            textField.placeholder = Constants.Join.passwordPlaceholder
            textField.isSecureTextEntry = true
            self.passwordTextField = textField
        }
        
        let loginAction = UIAlertAction(title: Constants.Login.buttonTitle, style: .default) { (_) in
            self.handleLoginAction(alertController: alertController)
        }
        
        let cancelAction = UIAlertAction(title: Constants.Alert.cancelTitle, style: .cancel, handler: nil)
        
        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func presentJoinAlert() {
        let alertController = UIAlertController(
            title: Constants.Join.title,
            message: Constants.Join.message,
            preferredStyle: .alert
        )
        alertController.view.tintColor = UIColor.purple
        
        alertController.addTextField { (textField) in
            textField.placeholder = Constants.Join.emailPlaceholder
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = Constants.Join.passwordPlaceholder
            textField.isSecureTextEntry = true
        }
        
        alertController.addTextField { textField in
            textField.placeholder = Constants.Join.passwordPlaceholder2
            textField.isSecureTextEntry = true
        }
        
        let joinAction = UIAlertAction(title: Constants.Join.buttonTitle, style: .default) { (_) in
            self.handleJoinAction(alertController: alertController)
        }
        
        let cancelAction = UIAlertAction(title: Constants.Alert.cancelTitle, style: .cancel, handler: nil)
        
        alertController.addAction(joinAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Input Validation
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: - Alert Display
    
    func showAlert(message: String, title: String = Constants.Alert.title) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.Alert.buttonTitle, style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Login Handling
    
    //김가빈 수정
    func performLogin(for member: Member) throws {
        showNextPage(segueIdentifier: "showTabBarController")
        // 로그인 성공 후 MemberStore의 currentLoggedInMember 업데이트
            MemberStore.shared.setCurrentLoggedInMember(member)
        // 다음 화면으로 이동하는 로직
            showNextPage(segueIdentifier: "showTabBarController")
    }
    //김가빈 수정 끝

    func handleLoginAction(alertController: UIAlertController) {
        guard let email = alertController.textFields?[0].text,
              let password = alertController.textFields?[1].text else {
            return
        }
        
        do {
            let member = try MemberStore.shared.loadMemberInfo()
            
            guard let member = member else {
                showAlert(message: Constants.Error.emailNotREgistered, title : Constants.Login.title)
                return
            }
            
            if isValidEmail(email), email == member.email, password == member.password {
                try performLogin(for: member)
            } else {
                var errorMessage = NSLocalizedString(Constants.Error.title, comment: "")
                
                if email != member.email {
                    errorMessage += "\n" + NSLocalizedString(Constants.Error.emailNotREgistered, comment: "")
                } else {
                    errorMessage += "\n" + NSLocalizedString(Constants.Error.mismatchedPasswords, comment: "")
                }
                
                showAlert(message: errorMessage)
            }
        } catch {
            showAlert(message:Constants.Error.loginFailed, title:Constants.Login.title)
        }
    }
    
    func handleJoinAction(alertController: UIAlertController) {
        if let email = alertController.textFields?[0].text,
           let password = alertController.textFields?[1].text,
           let confirmPassword = alertController.textFields?[2].text {
            
            if isValidEmail(email) {
                do {
                    if MemberStore.shared.isEmailRegistered(email) {
                        showAlert(message: Constants.Error.emailAlreadyRegistered, title: Constants.Join.title)
                    } else {
                        if !password.isEmpty && password == confirmPassword {
                            if isValidPassword(password) {
                                let member = Member(email: email, password: password)
                                try MemberStore.shared.saveMemberInfo(member)
                                print("이메일: \(email), 비밀번호: \(password)")
                            } else {
                                showAlert(message: Constants.Error.invalidPassword, title: Constants.Join.title)
                            }
                        } else {
                            showAlert(message: password.isEmpty ? Constants.Error.emptyPassword : Constants.Error.mismatchedPasswords, title: Constants.Join.title)
                        }
                    }
                } catch {
                    showAlert(message: Constants.Error.unknownError, title: Constants.Join.title)
                }
            } else {
                showAlert(message: Constants.Error.invalidEmail, title: Constants.Join.title)
            }
        }
    }
    
    // MARK: - Password Validation
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*()_+{}|<>?]).{8,16}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    // MARK: - Navigation
    func showNextPage(segueIdentifier: String) {
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }

    // MARK: - UI Button Layout
    
    func configureButtonConstraints() {

        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        loginButton.backgroundColor = UIColor.purple.withAlphaComponent(0.7)
        loginButton.layer.cornerRadius = 30
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        joinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        joinButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        joinButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        joinButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        joinButton.backgroundColor = UIColor.purple.withAlphaComponent(0.7)
        joinButton.layer.cornerRadius = 30
        joinButton.setTitleColor(UIColor.white, for: .normal)
        joinButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
    }

    // MARK: - UI Setup
    
    func setupButtons() {
        
        loginButton = UIButton(type: .system)
        loginButton.setTitle(Constants.Login.buttonTitle, for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)
        
        
        joinButton = UIButton(type: .system)
        joinButton.setTitle(Constants.Join.buttonTitle, for: .normal)
        joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
        view.addSubview(joinButton)
        
        configureButtonConstraints()
    }

    func setupSloganLabel() {
        sloganLabel = UILabel()
        sloganLabel.text = "Kick going - 간편하게 대여하고 즐겁게 이동하세요!"
        sloganLabel.textAlignment = .center
        sloganLabel.textColor = UIColor.black
        sloganLabel.numberOfLines = 2
        sloganLabel.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(sloganLabel)
        
        sloganLabel.translatesAutoresizingMaskIntoConstraints = false
        sloganLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sloganLabel.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -40).isActive = true
        sloganLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        sloganLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
}
