//
//  UITableVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/19/26.
//
/*
 Reference
 - https://developer.apple.com/documentation/uikit/uitableview
 - https://developer.apple.com/documentation/uikit/uitableviewdatasource
 - https://inuplace.tistory.com/1174
 */

import UIKit

final class UITableVC: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let data = ["Apple", "Banana", "Orange", "Pineapple", "Strawberry", "Blueberry", "Kiwi", "Mango", "Lemon", "Grape"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupUI()
    }
    
    func setupDelegate() {
        self.tableView.dataSource = self
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

extension UITableVC: UITableViewDataSource {
    // 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
        // return data[section].count
    }
    
    // 셀에 넣을 데이터
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: .none)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}
