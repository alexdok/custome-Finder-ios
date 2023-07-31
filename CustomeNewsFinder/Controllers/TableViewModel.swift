//
//  ViewModel.swift
//  CustomeNewsFinder
//
//  Created by алексей ганзицкий on 12.02.2023.
//

import Foundation
import UIKit

class TableViewModel {
    
    let networkManager: NetworkManager
    let saveManager: SaveManager = SaveManagerImpl.shared
    var page = 1
    var loadNewData = false
    var newsObjectData = Bindable<[ObjectNewsData?]>([])
    var data: [ObjectNewsData?]?
    var theme: String = "tesla"
    let networkMonitor = NetworkMonitor.shared
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func viewIsReady() -> Bool {
     //   networkMonitor.startMonitoring()
        if networkMonitor.isReachable {
            networkManager.sendRequestForNews(theme: theme, page: 1) { data in
                DispatchQueue.main.async {
                    self.newsObjectData.value = data
                }
            }
        }
        return networkMonitor.isReachable
    }
    
    func reloadData() {
        networkManager.sendRequestForNews(theme: theme, page: 1) { [weak self] data in
            DispatchQueue.main.async {
                self?.data = nil
                self?.newsObjectData.value = data
                self?.page = 1
            }
        }
    }
    
    func loadNewPageNews() {
        page += 1
        print(page)
        networkManager.sendRequestForNews(theme: theme, page: page) { [weak self] data in
                DispatchQueue.main.async {
                    self?.newsObjectData.value.append(contentsOf: data)
                }
        }
    }
    
    func loadImage(linkToImageNews: String,  completion: @escaping (UIImage) -> Void) {
        let group = DispatchGroup()
        group.enter()
        networkManager.loadImage(urlForImage: linkToImageNews) {  image in
            completion(image)
            group.leave()
        }
    }
    
    func updateTheme(to theme: String) {
        self.theme = theme
    }
}
