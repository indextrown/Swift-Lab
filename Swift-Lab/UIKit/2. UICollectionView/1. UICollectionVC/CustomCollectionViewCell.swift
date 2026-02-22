//
//  CustomCollectionViewCell.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/22/26.
//

import UIKit

extension CustomCollectionViewCell: ReuseIdentifiable {}
final class CustomCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
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
         contentView.backgroundColor = .systemBlue
         contentView.layer.cornerRadius = 12
         contentView.layer.masksToBounds = true
         
         contentView.addSubview(titleLabel)
         
         NSLayoutConstraint.activate([
             titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
             titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
         ])
     }
     
     func configure(text: String) {
         titleLabel.text = text
     }
}
