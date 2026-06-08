//
//  PaginationImgCell.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/20/26.
//

import UIKit

final class PaginationImgCell: UICollectionViewCell, ReuseIdentifiable {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private var currentImageURL: URL?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        currentImageURL = nil
    }
    
    private func setupUI() {
        contentView.backgroundColor = .systemBlue.withAlphaComponent(0.12)
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(item: PaginationItem) {
        titleLabel.text = item.title
        imageView.image = nil
        
        guard let imageURL = item.imageURL else { return }
        currentImageURL = imageURL
        
        ImageLoader.shared.loadImage(from: imageURL) { [weak self] image in
            guard let self else { return }
            guard self.currentImageURL == imageURL else { return }
            
            if Thread.isMainThread {
                self.imageView.image = image
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    guard self.currentImageURL == imageURL else { return }
                    self.imageView.image = image
                }
            }
        }
    }
}


struct PaginationItem {
    let id: Int
    let title: String
    let imageURL: URL?
}
