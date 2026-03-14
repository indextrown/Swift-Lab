//
//  SectionHeaderView.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/23/26.
//

import UIKit

extension AnimatedNumberSectionSectionHeaderView: ReuseIdentifiable {}

final class AnimatedNumberSectionSectionHeaderView: UICollectionReusableView {
    private let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(text: String) {
        label.text = text
    }
}
