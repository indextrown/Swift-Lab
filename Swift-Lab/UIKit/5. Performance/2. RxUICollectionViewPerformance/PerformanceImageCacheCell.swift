//
//  PerformanceCell.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/3/26.
//

import UIKit
import Kingfisher

extension PerformanceImageCacheCell: ReuseIdentifiable {}
final class PerformanceImageCacheCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(text: String, imageURL: URL) {
        label.text = text
        
        if self.bounds.size == .zero {
            print("사이즈가 0입니다")
        }
        
        // 다운샘플링 (🔥 매우 중요)
        let processor = DownsamplingImageProcessor(size: bounds.size)
        
        imageView.kf.setImage(
            with: imageURL,
            placeholder: nil,
            options: [
                .processor(processor),              // 셀 크기에 맞게 리사이징
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.2)),
                // .cacheOriginalImage                // 원본도 캐시
                
                // 🔥 메모리 캐시 비활성화
                .memoryCacheExpiration(.expired),
                
                // 디스크 캐시는 유지
                .diskCacheExpiration(.days(7))
            ]
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()   // 중요
        imageView.image = nil
        label.text = nil
    }
}


