import UIKit

// 킥보드 이용 내역을 위한 모델
struct KickboardUsageHistory {
    let name: String
    let number: String
    let time: Date
}

// 내가 등록한 킥보드를 위한 모델
struct RegisteredKickboard {
    let name: String
    let number: String
}

class MyPageViewController: UIViewController, UITableViewDataSource {
    
    var tableView: UITableView!
    var usageHistories: [KickboardUsageHistory] = []
    var registeredKickboards: [RegisteredKickboard] = []
    var currentUserEmail: String?
    
    // UI 요소 선언
    let backButton = UIButton(type: .system)
    let userIdLabel = UILabel()
    let statusLabel = UILabel()
    let usageHistoryLabel = UILabel()
    let registeredKickboardLabel = UILabel()
    let logoutButton = UIButton(type: .system)
//    let registerKickboardButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 현재 로그인한 사용자의 이메일을 가져옵니다.
        if let loggedInMember = MemberStore.shared.getCurrentLoggedInMember() {
            currentUserEmail = loggedInMember.email
        }
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registeredKickboards = DataStore.shared.getKickboards()
        self.tableView.reloadData()
    }
    
    func updateDataSource() {
        self.registeredKickboards = DataStore.shared.kickboards
    }
    
    @objc func registerKickboardButtonTapped() {
        let registerVC = RegisterViewController()
        registerVC.registrationDelegate = self
        present(registerVC, animated: true, completion: nil)
    }
    
    func setupUI() {
        // 전체 뷰의 배경색 설정
        view.backgroundColor = .white
        
        // UI 요소 초기화 및 뷰에 추가
        backButton.setTitle("뒤로", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // ID 라벨에 현재 사용자의 이메일을 표시합니다.
        userIdLabel.text = currentUserEmail ?? "ID"
        userIdLabel.textAlignment = .center
        userIdLabel.numberOfLines = 0
        userIdLabel.lineBreakMode = .byWordWrapping
        
        // 상태 라벨 설정
        if let userEmail = currentUserEmail {
            statusLabel.text = "\(userEmail) 님은 현재 킥고잉을 사용하고 계십니다."
        } else {
            statusLabel.text = "로그인을 해주세요."
        }
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.lineBreakMode = .byWordWrapping
        
        // 이용 내역 라벨 설정
        usageHistoryLabel.text = "킥보드 이용내역"
        registeredKickboardLabel.text = "내가 등록한 킥보드"
        logoutButton.setTitle("LogOut", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
//        // "킥보드 등록" 버튼 설정
//        registeredKickboardLabel.setTitle("킥보드 등록", for: .normal)
//        registeredKickboardLabel.addTarget(self, action: #selector(registerKickboardButtonTapped), for: .touchUpInside)
        
        // 뷰에 추가
//        view.addSubview(registerKickboardButton)
        view.addSubview(backButton)
        view.addSubview(userIdLabel)
        view.addSubview(statusLabel)
        view.addSubview(usageHistoryLabel)
        view.addSubview(registeredKickboardLabel)
        view.addSubview(logoutButton)
        
        setupConstraints()
    }
    
    
    
    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: registeredKickboardLabel.bottomAnchor, constant: 20),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -20),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    
    func setupConstraints() {
        // backButton 제약 조건
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 60),
            backButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // userIdLabel 제약 조건
        userIdLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userIdLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            userIdLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userIdLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userIdLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // statusLabel 제약 조건
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: userIdLabel.bottomAnchor, constant: 10),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // usageHistoryLabel 제약 조건
        usageHistoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usageHistoryLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            usageHistoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usageHistoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            usageHistoryLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // registeredKickboardLabel 제약 조건
        registeredKickboardLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            registeredKickboardLabel.topAnchor.constraint(equalTo: usageHistoryLabel.bottomAnchor, constant: 20),
            registeredKickboardLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            registeredKickboardLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            registeredKickboardLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
//        // "킥보드 등록" 버튼 제약 조건
//        registerKickboardButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            registerKickboardButton.topAnchor.constraint(equalTo: registeredKickboardLabel.bottomAnchor, constant: 20),
//            registerKickboardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            registerKickboardButton.widthAnchor.constraint(equalToConstant: 200),
//            registerKickboardButton.heightAnchor.constraint(equalToConstant: 50)
//        ])
        
        // logoutButton 제약 조건
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    // UITableViewDataSource 프로토콜을 준수하는 메서드 구현
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 두 개의 섹션: 이용 내역과 등록된 킥보드
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return usageHistories.count // 첫 번째 섹션은 이용 내역의 수를 반환
        } else {
            return registeredKickboards.count // 두 번째 섹션은 등록된 킥보드의 수를 반환
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
            let history = usageHistories[indexPath.row]
            cell.textLabel?.text = "\(history.name) - \(history.number)"
            cell.detailTextLabel?.text = "이용 시간: \(formatDate(history.time))"
        } else {
            let kickboard = registeredKickboards[indexPath.row]
            cell.textLabel?.text = "\(kickboard.name) - \(kickboard.number)"
        }
        
        return cell
    }
    
    // 날짜를 문자열로 변환하는 메서드
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // 로그아웃 버튼이 눌렸을 때 호출되는 메서드
    @objc func logoutButtonTapped() {
        // 로그아웃 로직 구현
        // 로그아웃 알림 창 설정
        let alertController = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        
        // '네'를 선택했을 때의 액션 정의
        let confirmAction = UIAlertAction(title: "네", style: .default) { [weak self] _ in
            // 로그아웃 처리
            MemberStore.shared.logout()
            
            // 로그아웃 성공 알림 창 표시
            let logoutAlert = UIAlertController(title: "로그아웃 되었습니다", message: "로그아웃 되었습니다:)", preferredStyle: .alert)
            logoutAlert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                // 로그인 화면으로 돌아가기
                self?.dismiss(animated: true, completion: nil)
            })
            self?.present(logoutAlert, animated: true, completion: nil)
        }
        
        
        // '아니오'를 선택했을 때의 액션 정의
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        // 액션을 알림 창에 추가
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        // 알림 창 표시
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func backButtonTapped() {
        // 뒤로가기 로직 구현
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - RegistrationDelegate

extension MyPageViewController: RegistrationDelegate {
    func didRegisterKickboard(name: String, number: String, latitude: Double, longitude: Double) {
        let newKickboard = RegisteredKickboard(name: name, number: number)
        self.registeredKickboards.append(newKickboard)
        self.tableView.reloadData()
    }
}
