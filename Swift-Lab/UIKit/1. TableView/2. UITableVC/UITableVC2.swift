//
//  UITableVC2.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/19/26.
//
/*
 Reference
 - https://developer.apple.com/documentation/uikit/uitableview
 - https://developer.apple.com/documentation/uikit/uitableviewdatasource
 - https://inuplace.tistory.com/1174
 - https://jeonyeohun.tistory.com/244
 - https://ios-development.tistory.com/991
 */

import UIKit

final class UITableVC2: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let sections = ["Section 1", "Section 2", "Section 3"]
    let data = [["Apple", "Banana", "Orange"], ["Pineapple", "Strawberry", "Blueberry"], ["Pineapple", "Strawberry", "Blueberry", "Kiwi", "Mango", "Lemon", "Grape"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupUI()
    }
    
    func setupDelegate() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension UITableVC2: UITableViewDataSource {
    // cell 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    // cell에 넣을 데이터
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: UITableViewCell.reuseIdentifier)
        cell.textLabel?.text = data[indexPath.section][indexPath.row]
        return cell
    }
    
    // section 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // Section의 header 이름 정의
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
}

extension UITableVC2: UITableViewDelegate {
    // cell 선택 액션
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.backgroundColor = .green
    }
    
    // cell 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
