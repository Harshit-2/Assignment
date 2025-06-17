//
//  ReportViewModel.swift
//  Assignment
//
//  Created by Harshit ‎ on 6/16/25.
//

import Foundation
import PDFKit

protocol ReportViewModelDelegate: AnyObject {
    func didLoadPDF(_ document: PDFDocument)
    func didFailToLoadPDF(_ error: Error)
}

class ReportViewModel {
    weak var delegate: ReportViewModelDelegate?
    
    func loadPDF() {
        guard let url = URL(string: Constants.pdfURL) else {
            delegate?.didFailToLoadPDF(NSError(domain: "PDFError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid PDF URL"]))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.delegate?.didFailToLoadPDF(error)
                    return
                }
                
                guard let data = data, let document = PDFDocument(data: data) else {
                    self?.delegate?.didFailToLoadPDF(NSError(domain: "PDFError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load PDF"]))
                    return
                }
                
                self?.delegate?.didLoadPDF(document)
            }
        }.resume()
    }
}
