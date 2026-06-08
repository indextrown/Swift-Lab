//
//  FruitCell.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/19/26.
//

import UIKit

final class FruitCell: UICollectionViewCell {
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - required
    /// 코드로 셀을 생성할 때 호출되는 필수 초기화 메서드입니다.
    /// 셀의 기본 UI 구성과 레이아웃 설정을 수행합니다.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    /// 스토리보드/XIB 기반 초기화 메서드입니다.
    /// 현재 예제는 코드 기반 UI만 사용하므로 지원하지 않습니다.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Reuse
    /// 셀이 재사용되기 전에 이전 데이터를 초기화합니다.
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        contentView.backgroundColor = nil
    }
    
    // MARK: - Configure
    /// 셀에 표시할 데이터를 적용합니다.
    /// - Parameter fruit: 셀에 바인딩할 과일 데이터
    func configure(with fruit: Fruit) {
        titleLabel.text = fruit.name
        contentView.backgroundColor = fruit.color
    }
    
    // MARK: - Private
    /// 셀의 기본 스타일을 설정합니다.
    private func setupUI() {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.addSubview(titleLabel)
    }
    
    /// 셀 내부 레이아웃 제약 조건을 설정합니다.
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
