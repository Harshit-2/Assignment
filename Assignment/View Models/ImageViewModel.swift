//
//  ImageViewModel.swift
//  Assignment
//
//  Created by Harshit ‎ on 6/16/25.
//

import UIKit

protocol ImageViewModelDelegate: AnyObject {
    func didSelectImage(_ image: UIImage)
}

class ImageViewModel: NSObject {
    weak var delegate: ImageViewModelDelegate?
    private weak var presentingViewController: UIViewController?
    
    func presentImagePicker(from viewController: UIViewController) {
        presentingViewController = viewController
        
        let alert = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                self?.openImagePicker(.camera)
            })
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
                self?.openImagePicker(.photoLibrary)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
        }
        
        viewController.present(alert, animated: true)
    }
    
    private func openImagePicker(_ sourceType: UIImagePickerController.SourceType) {
        guard let presentingViewController = presentingViewController else { return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        presentingViewController.present(imagePicker, animated: true)
    }
}

extension ImageViewModel: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let editedImage = info[.editedImage] as? UIImage {
            delegate?.didSelectImage(editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            delegate?.didSelectImage(originalImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

