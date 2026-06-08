//
//  PageContentVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/21/26.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - Page Item
/// 개별 페이지 화면
final class PageItemViewController: UIViewController {

    private let text: String

    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(text: String, color: UIColor) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = color
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        label.text = text
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Page Demo ViewController
/// UIPageViewController + Rx DelegateProxy 샘플
final class PageDemoVC: UIViewController {

    private let disposeBag = DisposeBag()

    private lazy var pages: [UIViewController] = [
        PageItemViewController(text: "Page 1", color: .systemRed),
        PageItemViewController(text: "Page 2", color: .systemBlue),
        PageItemViewController(text: "Page 3", color: .systemGreen)
    ]

    private lazy var pageVC: UIPageViewController = {
        let vc = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupPage()
        bind()
    }

    private func setupLayout() {
        view.backgroundColor = .systemBackground

        addChild(pageVC)
        view.addSubview(pageVC.view)

        NSLayoutConstraint.activate([
            pageVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        pageVC.didMove(toParent: self)
    }

    private func setupPage() {
        guard let first = pages.first else { return }

        pageVC.setViewControllers(
            [first],
            direction: .forward,
            animated: false
        )
    }

    private func bind() {
        pageVC.rx.setDelegate()

        pageVC.rx.setDataSource(
            before: { [weak self] vc in
                guard let self,
                      let index = self.pageIndex(for: vc),
                      index > 0 else { return nil }

                // print("이전:", index + 1, "->", index)
                return self.pages[index - 1]
            },
            after: { [weak self] vc in
                guard let self,
                      let index = self.pageIndex(for: vc),
                      index < self.pages.count - 1 else { return nil }

                // print("다음:", index + 1, "->", index + 2)
                return self.pages[index + 1]
            }
        )

        pageVC.rx.didFinishAnimating
            .compactMap { [weak self] in
                guard let self,
                      let current = self.pageVC.viewControllers?.first,
                      let index = self.pageIndex(for: current) else { return nil }

                return index
            }
            .subscribe(onNext: { index in
                print("📄 현재 페이지:", index + 1)
            })
            .disposed(by: disposeBag)
    }

    private func pageIndex(for viewController: UIViewController) -> Int? {
        pages.firstIndex { $0 === viewController }
    }
}


// MARK: - Reactive Extension
extension Reactive where Base: UIPageViewController {

    private var proxy: RxPageViewControllerDataSourceProxy {
        RxPageViewControllerDataSourceProxy.proxy(for: base)
    }

    private var delegateProxy: RxPageViewControllerDelegateProxy {
        RxPageViewControllerDelegateProxy.proxy(for: base)
    }

    func setDataSource(
        before: @escaping (UIViewController) -> UIViewController?,
        after: @escaping (UIViewController) -> UIViewController?
    ) {
        let proxy = self.proxy
        proxy.beforeHandler = before
        proxy.afterHandler = after

        base.dataSource = proxy
    }

    var didFinishAnimating: Observable<Void> {
        delegateProxy.didFinishAnimatingSubject.asObservable()
    }

    func setDelegate() {
        base.delegate = delegateProxy
    }
}

// MARK: - Delegate Proxy
final class RxPageViewControllerDataSourceProxy:
    DelegateProxy<UIPageViewController, UIPageViewControllerDataSource>,
    DelegateProxyType,
    UIPageViewControllerDataSource {

    var beforeHandler: ((UIViewController) -> UIViewController?)?
    var afterHandler: ((UIViewController) -> UIViewController?)?

    init(pageVC: UIPageViewController) {
        super.init(parentObject: pageVC, delegateProxy: RxPageViewControllerDataSourceProxy.self)
    }

    static func registerKnownImplementations() {
        self.register { RxPageViewControllerDataSourceProxy(pageVC: $0) }
    }

    static func currentDelegate(for object: UIPageViewController) -> UIPageViewControllerDataSource? {
        object.dataSource
    }

    static func setCurrentDelegate(_ delegate: UIPageViewControllerDataSource?, to object: UIPageViewController) {
        object.dataSource = delegate
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        beforeHandler?(viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        afterHandler?(viewController)
    }
}

final class RxPageViewControllerDelegateProxy:
    DelegateProxy<UIPageViewController, UIPageViewControllerDelegate>,
    DelegateProxyType,
    UIPageViewControllerDelegate {

    let didFinishAnimatingSubject = PublishSubject<Void>()

    init(pageVC: UIPageViewController) {
        super.init(parentObject: pageVC, delegateProxy: RxPageViewControllerDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        self.register { RxPageViewControllerDelegateProxy(pageVC: $0) }
    }

    static func currentDelegate(for object: UIPageViewController) -> UIPageViewControllerDelegate? {
        object.delegate
    }

    static func setCurrentDelegate(_ delegate: UIPageViewControllerDelegate?, to object: UIPageViewController) {
        object.delegate = delegate
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard finished, completed else { return }

        didFinishAnimatingSubject.onNext(())
        _forwardToDelegate?.pageViewController?(
            pageViewController,
            didFinishAnimating: finished,
            previousViewControllers: previousViewControllers,
            transitionCompleted: completed
        )
    }
}
