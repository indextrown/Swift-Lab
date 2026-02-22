//
//  Cell.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/21/26.
//
/*
 https://jiwift.tistory.com/entry/iOSSwift-UITableViewCell-코드로-구현
 */

import UIKit

final class TestCell: UITableViewCell {
    
    // 초기화 메서드: 스타일과 재사용 식별자를 매개변수로 받아 초기화를 수행합니다
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    // Storyboard/XIB 사용을 지원하지 않음 (코드 기반 UI 전용)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Nib 파일로부터 객체가 초기화된 후 호출되는 메서드
    override func awakeFromNib() {
        super.awakeFromNib()
        // 추가적인 초기화 작업을 여기에 작성(코드베이스이면 절대 실행되지 않음)
    }
    
    // 셀의 선택 상태 변경시 호출되는 메서드
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // 선택 상태 변경 시 추가 작업을 여기에 작성
    }
    
    // 공통 초기화 작업을 수행하는 메서드
    private func commonInit() {
        // 공통 초기화 코드를 여기에 작성
    }
}
