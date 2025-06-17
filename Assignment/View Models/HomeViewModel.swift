//
//  HomeViewModel.swift
//  Assignment
//
//  Created by Harshit ‎ on 6/16/25.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didFetchData()
    func didFailWithError(_ error: Error)
    func didUpdateData()
    func didDeleteData(_ item: DataItem)
}

class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    private(set) var dataItems: [DataItem] = []
    
    func fetchDataFromAPI() {
        APIManager.shared.fetchData { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    CoreDataManager.shared.saveDataItems(items)
                    self?.loadDataFromCoreData()
                case .failure(let error):
                    self?.delegate?.didFailWithError(error)
                }
            }
        }
    }
    
    func loadDataFromCoreData() {
        dataItems = CoreDataManager.shared.fetchDataItems()
        delegate?.didFetchData()
    }
    
    func updateItem(_ item: DataItem, name: String, data: String?) {
        CoreDataManager.shared.updateDataItem(item, name: name, data: data)
        loadDataFromCoreData()
        delegate?.didUpdateData()
    }
    
    func deleteItem(_ item: DataItem) {
        NotificationManager.shared.sendDeleteNotification(for: item)
        CoreDataManager.shared.deleteDataItem(item)
        loadDataFromCoreData()
        delegate?.didDeleteData(item)
    }
}
