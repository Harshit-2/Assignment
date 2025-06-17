//
//  ImageViewController.swift
//  Assignment
//
//  Created by Harshit ‎ on 6/16/25.
//

import UIKit
import AVFoundation
import Photos

class ImageViewController: UIViewController {
    private let viewModel = ImageViewModel()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = Constants.Colors.cellBackgroundColor
        imageView.setCornerRadius(10)
        imageView.image = UIImage(systemName: "photo.badge.plus")
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    private let selectImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Image", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.Colors.primaryColor
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupViewModel()
        requestPermissions()
    }
    
    private func setupUI() {
        title = "Images"
        view.backgroundColor = Constants.Colors.backgroundColor
        
        view.addSubview(imageView)
        view.addSubview(selectImageButton)
        
        selectImageButton.addTarget(self, action: #selector(selectImageTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.75),
            
            selectImageButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            selectImageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            selectImageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            selectImageButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func requestPermissions() {
        // Request camera permission
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if !granted {
                print("Camera permission denied")
            }
        }
        
        // Request photo library permission
        PHPhotoLibrary.requestAuthorization { status in
            if status != .authorized {
                print("Photo library permission denied")
            }
        }
    }
    
    @objc private func selectImageTapped() {
        viewModel.presentImagePicker(from: self)
    }
}

extension ImageViewController: ImageViewModelDelegate {
    func didSelectImage(_ image: UIImage) {
        imageView.image = image
    }
}
