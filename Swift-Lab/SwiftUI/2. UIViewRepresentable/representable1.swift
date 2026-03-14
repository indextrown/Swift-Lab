//
//  representable1.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/14/26.
//

/**
 https://ios-development.tistory.com/1043
 https://heidi-dev.tistory.com/7
 https://green1229.tistory.com/533
 https://toughie-ios.tistory.com/261
 */
import UIKit
import SwiftUI

struct RepresentableSampleView: View {
    @State private var text: String = ""
    var body: some View{
        VStack {
            UITextFieldViewRepresentable(text: $text)
                .updatePlaceholderColor(.red)
                .updatePlaceholder("hello world")
                .padding(.leading, 20)
                .frame(height: 55)
                .background(Color.gray)
                .cornerRadius(15)
                .padding()
        }
    }
}

#Preview {
    RepresentableSampleView()
}

struct UITextFieldViewRepresentable: UIViewRepresentable {
    var placeHolder: String
    var placeHolderColor: UIColor
    @Binding var text: String
    
    init(
        text: Binding<String>,
        placeHolder: String = "Default Placeholder",
        placeHolderColor: UIColor = .white
    ) {
        self.placeHolder = placeHolder
        self.placeHolderColor = placeHolderColor
        self._text = text
    }
    
    func makeUIView(
        context: Context
    ) -> UITextField {
        let textField = makeTextField()
        textField.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(
        _ uiView: UITextField,
        context: Context
    ) {
        // text update
        uiView.text = text
        
        // placeholder update
        let placeholder = NSAttributedString(
            string: placeHolder,
            attributes: [
                .foregroundColor: placeHolderColor
            ]
        )
        uiView.attributedPlaceholder = placeholder
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        init(text: Binding<String>) {
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
}

// MARK: - Private
private extension UITextFieldViewRepresentable {
    func makeTextField() -> UITextField {
        let textField = UITextField(frame: .zero)
        return textField
    }
}

// MARK: - Public
extension UITextFieldViewRepresentable {
    func updatePlaceholder(
        _ text: String
    ) -> UITextFieldViewRepresentable {
        var viewRepresentable = self
        viewRepresentable.placeHolder = text
        return viewRepresentable
    }
    
    func updatePlaceholderColor(
        _ color: UIColor
    ) -> UITextFieldViewRepresentable {
        var viewRepresentable = self
        viewRepresentable.placeHolderColor = color
        return viewRepresentable
    }
}
