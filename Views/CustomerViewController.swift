//
//  CustomerViewController.swift
//  Kick_Going
//
//  Created by t2023-m0024 on 1/18/24.
//

import UIKit

class CustomerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let firstTableView = UITableView()
    let secondTableView = UITableView()

    let firstTableData = ["도움이 필요하신가요?", "카카오톡 문의하기"]
    let secondTableData = ["공지사항(이벤트)", "이용방법", "상품안내", "결제수단 등록"]

    override func viewDidLoad() {
        super.viewDidLoad()

        firstTableView.dataSource = self
        firstTableView.delegate = self
        firstTableView.register(UITableViewCell.self, forCellReuseIdentifier: "firstCell")
        view.addSubview(firstTableView)

        secondTableView.dataSource = self
        secondTableView.delegate = self
        secondTableView.register(UITableViewCell.self, forCellReuseIdentifier: "secondCell")
        view.addSubview(secondTableView)

        firstTableView.separatorStyle = .none
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let tableWidth = view.bounds.width / 1.2
        let tableHeight = view.bounds.height * 3 / 4
        let xPosition = (view.bounds.width - tableWidth) / 2 // 중앙 정렬

        firstTableView.frame = CGRect(x: xPosition, y: 100, width: tableWidth, height: tableHeight)
        secondTableView.frame = CGRect(x: xPosition, y: 300, width: tableWidth, height: tableHeight)
    }

    // MARK: - UITableViewDataSource methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == firstTableView ? firstTableData.count : secondTableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = tableView == firstTableView ? "firstCell" : "secondCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let data = tableView == firstTableView ? firstTableData[indexPath.row] : secondTableData[indexPath.row]
        cell.textLabel?.text = data

        if tableView == firstTableView && indexPath.row == 1 {
            let button = UIButton(type: .system)
            button.setTitle("카카오톡 문의하기", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .yellow
            button.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)

            let buttonWidth: CGFloat = 280
            let buttonHeight: CGFloat = 44
            let xPosition = (cell.contentView.bounds.width - buttonWidth) / 2
            let yPosition = (cell.contentView.bounds.height - buttonHeight) / 2
            button.frame = CGRect(x: xPosition, y: yPosition, width: buttonWidth, height: buttonHeight)

            cell.accessoryView = button
        }

        return cell
    }

    // MARK: - Button Action

    @objc func kakaoButtonTapped() {
        // 카카오톡 문의하기 버튼이 탭되었을 때 수행할 동작 추가
        print("카카오톡 문의하기 버튼이 탭되었습니다.")
    }

    // MARK: - UITableViewDelegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0 // 원하는 높이로 설정
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 테이블 뷰의 특정 행이 선택되었을 때 수행할 동작 추가
        print("선택된 행: \(indexPath.row)")
    }
}
