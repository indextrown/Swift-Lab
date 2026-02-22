//
//  ImagePickerVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/22/26.
//
/*
 https://zeddios.tistory.com/1187
 https://hururuek-chapchap.tistory.com/64

 "NSCameraUsageDescription" = "카메라 사용을 허용해주세용~!";
 "NSPhotoLibraryAddUsageDescription" = "사진 앨범 가져오게 허용해주세용~";

 UIImagePickerControllerDelegate
 - 이미지를 선택하고 카메라를 찍었을 때 다양한 동작을 도와준다

 UINavigationControllerDelegate
 - 앨범 사진을 선택했을 때 화면 전환을 네비게이션으로 이동한다
 */

import UIKit

final class ImagePickerVC: UIViewController {

    // MARK: - UI
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Image Picker", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemGray6
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            nil,
            action: #selector(actionAlert),
            for: .touchUpInside
        )
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc func actionAlert() {
        let alert = UIAlertController(
            title: "선택",
            message: nil,
            preferredStyle: .actionSheet
        )
        let camera = UIAlertAction(title: "카메라", style: .default) { _ in

        }

        let album = UIAlertAction(title: "앨범", style: .default) {
            [weak self] _ in
            self?.presentPicker(source: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(camera)
        alert.addAction(album)
        present(alert, animated: true, completion: nil)
    }

}

extension ImagePickerVC: UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{

    // 이미지 피커 화면
    private func presentPicker(source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            print("사용 불가")
            return
        }

        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = false
        present(picker, animated: true)
    }

    // delegate: 이미지 선택
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:
            Any]
    ) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            print("이미지 선택 완료: \(image)")
        }
    }

    // delegate: 뒤로가기
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        print("뒤로가기")
    }
}

#Preview {
    ImagePickerVC()
}
