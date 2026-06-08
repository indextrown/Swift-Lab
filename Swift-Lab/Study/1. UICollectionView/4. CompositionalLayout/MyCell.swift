//
//  MyCell.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/23/26.
//

import UIKit

extension MyCell: ReuseIdentifiable {}
final class MyCell: UICollectionViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    private func setupConstraints() {
        self.contentView.backgroundColor = .systemGray
        self.contentView.addSubview(self.label)
        NSLayoutConstraint.activate([
            self.label.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        label.text = text
    }
}
