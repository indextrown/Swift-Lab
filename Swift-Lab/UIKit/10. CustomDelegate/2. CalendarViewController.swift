//
//  AViewController.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/26/26.
//

import UIKit

protocol CalendarScrollDelegate: AnyObject {
    // 캘린더 스크롤 시작 이벤트
    func calendarDidStartScrolling()
    
    // 캘린더 스크롤 종료 이벤트
    func calendarDidEndScrolling()
}

final class CalendarViewController: UIViewController {
    
    weak var gestureDelegate: CalendarScrollDelegate?
    
    private let calendarView = UIScrollView() // FSCalendar 대신 간단히
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupUI()
        setupGesture()
    }
    
    private func setupUI() {
        calendarView.backgroundColor = .black
        view.addSubview(calendarView)
        calendarView.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
        
        // 가로 스크롤 활성화
        calendarView.isPagingEnabled = true
        calendarView.showsHorizontalScrollIndicator = true
        
        let width = view.bounds.width
        
        // contentSize 설정 (좌우 2페이지)
        calendarView.contentSize = CGSize(width: width * 2, height: 300)
        
        // 👉 첫 번째 페이지 (파란색)
        let page1 = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 300))
        page1.backgroundColor = .blue
        
        let label1 = UILabel(frame: page1.bounds)
        label1.text = "Calendar Page 1"
        label1.textAlignment = .center
        label1.textColor = .white
        page1.addSubview(label1)
        
        // 👉 두 번째 페이지 (초록색)
        let page2 = UIView(frame: CGRect(x: width, y: 0, width: width, height: 300))
        page2.backgroundColor = .green
        
        let label2 = UILabel(frame: page2.bounds)
        label2.text = "Calendar Page 2"
        label2.textAlignment = .center
        label2.textColor = .white
        page2.addSubview(label2)
        
        calendarView.addSubview(page1)
        calendarView.addSubview(page2)
    }
    
//    private func setupUI() {
//        calendarView.backgroundColor = .blue
//        view.addSubview(calendarView)
//        calendarView.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
//        
//        // 가로 스크롤 가능하게
//        calendarView.contentSize = CGSize(width: view.bounds.width * 2, height: 300)
//    }
    
    
    private func setupGesture() {
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
//        calendarView.addGestureRecognizer(pan)
        calendarView.panGestureRecognizer.addTarget(self, action: #selector(handlePan))
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            gestureDelegate?.calendarDidStartScrolling()
        case .ended, .cancelled:
            gestureDelegate?.calendarDidEndScrolling()
        default:
            break
        }
    }
}

//
//final class CalendarViewController: UIViewController {
//    
//    // ..
//    weak var gestureDelegate: CalendarScrollDelegate?
//    
//    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
//        switch gesture.state {
//        case .began:
//            // 캘린더 스크롤 시작했다고 이벤트 전달
//            gestureDelegate?.calendarDidStartScrolling()
//        case .ended, .cancelled:
//            // 캘린더 스크롤 종료했다고 이벤트 전달
//            gestureDelegate?.calendarDidEndScrolling()
//        default:
//            break
//        }
//    }
//}
