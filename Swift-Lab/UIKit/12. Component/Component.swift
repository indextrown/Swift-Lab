//
//  Component.swift
//  Swift-Lab
//
//  Created by 김동현 on 5/9/26.
//

import SwiftUI

// MARK: - Component Protocol
public protocol Component {
    associatedtype ViewModel: Equatable
    associatedtype Content: UIView
    associatedtype Coordinator = Void
    
    var viewModel: ViewModel { get }
    
    func makeView(coordinator: Coordinator) -> Content
    func updateView(_ view: Content, coordinator: Coordinator)
    func layoutView(_ view: Content, in container: UIView)
    func makeCoordinator() -> Coordinator
}

public extension Component {
    func toSwiftUI() -> some View {
        ComponentRepresentable(component: self)
    }
}

public extension Component where Coordinator == Void {
    func makeCoordinator() -> Coordinator {
        ()
    }
}

public extension Component where Content: UIView {
    func layoutView(_ view: Content, in container: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: container.topAnchor),
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
    }
}

// MARK: - SwiftUI Bridge
public struct ComponentRepresentable<C: Component>: UIViewRepresentable {
    public typealias UIViewType = ComponentContainerView<C.Content>
    public typealias Coordinator = C.Coordinator
    
    private let component: C
    
    public init(component: C) {
        self.component = component
    }
    
    public func makeCoordinator() -> Coordinator {
        component.makeCoordinator()
    }
    
    public func makeUIView(context: Context) -> UIViewType {
        let content = component.makeView(coordinator: context.coordinator)
        let container = UIViewType(content: content)
        component.layoutView(content, in: container)
        component.updateView(content, coordinator: context.coordinator)
        return container
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        component.updateView(uiView.content, coordinator: context.coordinator)
    }
    
    public func sizeThatFits(
        _ proposal: ProposedViewSize,
        uiView: UIViewType,
        context: Context
    ) -> CGSize? {
        let targetSize = CGSize(
            width: proposal.width ?? UIView.layoutFittingCompressedSize.width,
            height: proposal.height ?? UIView.layoutFittingCompressedSize.height
        )
        
        return uiView.autoLayoutFittingSize(
            for: targetSize,
            targetWidth: proposal.width
        )
    }
}

public final class ComponentContainerView<Content: UIView>: UIView {
    let content: Content
    
    init(content: Content) {
        self.content = content
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct PrimaryButtonComponent: Component, Equatable {
    struct ViewModel: Equatable {
        let title: String
        let isEnabled: Bool
    }
    
    let viewModel: ViewModel
    let onTap: () -> Void
    
    func makeView(coordinator: Void) -> PrimaryButton {
        PrimaryButton()
    }
    
    func updateView(_ view: PrimaryButton, coordinator: Void) {
        view.configure(viewModel: viewModel, onTap: onTap)
    }
    
    func layoutView(_ view: PrimaryButton, in container: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: container.topAnchor),
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            view.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.viewModel == rhs.viewModel
    }
}

final class PrimaryButton: UIButton {
    private var tapHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        configuration.contentInsets = .init(top: 14, leading: 20, bottom: 14, trailing: 20)
        configuration.cornerStyle = .medium
        self.configuration = configuration
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    func configure(viewModel: PrimaryButtonComponent.ViewModel, onTap: @escaping () -> Void) {
        configuration?.title = viewModel.title
        isEnabled = viewModel.isEnabled
        alpha = viewModel.isEnabled ? 1.0 : 0.5
        tapHandler = onTap
    }
    
    @objc
    private func didTap() {
        tapHandler?()
    }
}

private struct PrimaryButtonSampleView: View {
    @State private var tapCount = 0
    @State private var isEnabled = true
    
    var body: some View {
        VStack(spacing: 16) {
            Text("tapCount: \(tapCount)")
                .font(.headline)
            
            PrimaryButtonComponent(
                viewModel: .init(
                    title: isEnabled ? "Primary Button" : "Disabled",
                    isEnabled: isEnabled
                ),
                onTap: {
                    tapCount += 1
                }
            )
            .toSwiftUI()

            
            Button(isEnabled ? "Disable" : "Enable") {
                isEnabled.toggle()
            }
        }
        .padding()
    }
}

#Preview {
    PrimaryButtonSampleView()
}

private final class PrimaryButtonViewController: UIViewController {
    private var tapCount = 0 {
        didSet {
            countLabel.text = "tapCount: \(tapCount)"
        }
    }
    
    private var isPrimaryButtonEnabled = true {
        didSet {
            updatePrimaryButton()
            toggleButton.setTitle(isPrimaryButtonEnabled ? "Disable" : "Enable", for: .normal)
        }
    }
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = "tapCount: 0"
        return label
    }()
    
    private let primaryButton = PrimaryButton()
    
    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Disable", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        updatePrimaryButton()
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [countLabel, primaryButton, toggleButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        toggleButton.addTarget(self, action: #selector(didTapToggle), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func updatePrimaryButton() {
        primaryButton.configure(
            viewModel: .init(
                title: isPrimaryButtonEnabled ? "Primary Button" : "Disabled",
                isEnabled: isPrimaryButtonEnabled
            ),
            onTap: { [weak self] in
                self?.tapCount += 1
            }
        )
    }
    
    @objc
    private func didTapToggle() {
        isPrimaryButtonEnabled.toggle()
    }
}

#Preview("ViewController") {
    PrimaryButtonViewController()
}

private extension UIView {
    func autoLayoutFittingSize(
        for size: CGSize,
        targetWidth: CGFloat? = nil,
        minimumHeight: CGFloat = 0
    ) -> CGSize {
        let resolvedWidth = targetWidth.map { max($0, 1) }
        let fittingSize = CGSize(
            width: resolvedWidth ?? UIView.layoutFittingCompressedSize.width,
            height: UIView.layoutFittingCompressedSize.height
        )
        
        let result = systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: resolvedWidth == nil ? .fittingSizeLevel : .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return CGSize(
            width: resolvedWidth ?? ceil(result.width),
            height: max(ceil(result.height), minimumHeight)
        )
    }
}
