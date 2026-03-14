//
//  PerformanceCell.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/3/26.
//

import UIKit

extension PerformanceCell: ReuseIdentifiable {}
final class PerformanceCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let label = UILabel()
    private var currentTask: URLSessionDataTask?
    
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
    
//    func configure(text: String, image: UIImage?) {
//        label.text = text
//        imageView.image = image
//    }
//    
//    /// 🔥 재사용 대비 (메모리 실험 핵심)
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
//        imageView.image = nil
//        label.text = nil
//        
//        print("셀 재사용됨")
//    }
    
    func configure(text: String, imageURL: URL) {
        label.text = text
        imageView.image = nil
        // 재사용 대비
        currentTask?.cancel()
        currentTask = URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, _ in
            guard let data,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
        
        currentTask?.resume()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 반드시 취소
        currentTask?.cancel()
        imageView.image = nil
        label.text = nil
    }
}


