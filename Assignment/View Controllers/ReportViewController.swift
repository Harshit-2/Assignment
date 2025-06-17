//
//  ReportViewController.swift
//  Assignment
//
//  Created by Harshit ‎ on 6/16/25.
//

import UIKit
import PDFKit

class ReportViewController: UIViewController {
    private let viewModel = ReportViewModel()
    
    private let pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.autoScales = true
        return pdfView
    }()
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupViewModel()
        loadPDF()
    }
    
    private func setupUI() {
        title = "Report"
        view.backgroundColor = Constants.Colors.backgroundColor
        
        view.addSubview(pdfView)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func loadPDF() {
        loadingIndicator.startAnimating()
        viewModel.loadPDF()
    }
}

extension ReportViewController: ReportViewModelDelegate {
    func didLoadPDF(_ document: PDFDocument) {
        loadingIndicator.stopAnimating()
        pdfView.document = document
    }
    
    func didFailToLoadPDF(_ error: Error) {
        loadingIndicator.stopAnimating()
        showAlert(title: "Error", message: "Failed to load PDF: \(error.localizedDescription)")
    }
}
