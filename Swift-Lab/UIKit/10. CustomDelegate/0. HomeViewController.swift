////
////  HomeViewController.swift
////  Swift-Lab
////
////  Created by 김동현 on 3/26/26.
////
//
//import UIKit
//
//final class HomeViewController: UIViewController {
//    
//    private let pageVC = UIPageViewController(
//        transitionStyle: .scroll,
//        navigationOrientation: .horizontal
//    )
//    
//    private let feedVC = FeedViewController()
//    private let calendarVC = CalendarViewController()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        
//        setupPageVC()
//        
//        // ⭐️ 연결 (핵심)
//        calendarVC.gestureDelegate = self
//    }
//    
//    private func setupPageVC() {
//        addChild(pageVC)
//        view.addSubview(pageVC.view)
//        pageVC.view.frame = view.bounds
//        pageVC.didMove(toParent: self)
//        
//        pageVC.setViewControllers([feedVC], direction: .forward, animated: false)
//        
//        pageVC.dataSource = self
//    }
//    
//    // ⭐️ PageViewController 내부 scrollView
//    private var scrollView: UIScrollView? {
//        pageVC.view.subviews.first { $0 is UIScrollView } as? UIScrollView
//    }
//}
//
//extension HomeViewController: CalendarScrollDelegate {
//
//    func calendarDidStartScrolling() {
//        scrollView?.isScrollEnabled = false
//    }
//    
//    func calendarDidEndScrolling() {
//        scrollView?.isScrollEnabled = true
//    }
//}
//extension HomeViewController: UIPageViewControllerDataSource {
//    
//    func pageViewController(_ pageViewController: UIPageViewController,
//                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        return viewController === calendarVC ? feedVC : nil
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController,
//                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        return viewController === feedVC ? calendarVC : nil
//    }
//}
//
//
//final class HomeViewController: UIViewController {
//    calendarVC.gestureDelegate = self
//    // ..
//}
//
//extension HomeViewController: CalendarScrollDelegate {
//    
//    func calendarDidStartPan() {
//        scrollView?.isScrollEnabled = false
//    }
//    
//    func calendarDidEndPan() {
//        scrollView?.isScrollEnabled = true
//    }
//}
