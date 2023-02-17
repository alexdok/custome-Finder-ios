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
    var theme: String = "blizzard"
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func viewIsready() {
        networkManager.sendRequestForNews(theme: theme, page: 1) { data in
            DispatchQueue.main.async {
                self.newsObjectData.value = data
            }
        }
    }
    
    func reloadData() {
        networkManager.sendRequestForNews(theme: theme, page: 1) { [weak self] data in
            DispatchQueue.main.async {
                self?.data = nil
                self?.newsObjectData.value = data
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
//            if data.count < 20 {
//                self?.page = 0
//                self?.loadNewPageNews()
//            }
        }
    }
    
    func loadImage(linkToImageNews: String,  completion: @escaping (UIImage) -> Void) {
        networkManager.loadImage(urlForImage: linkToImageNews) {  image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    func updateTheme(to theme: String) {
        self.theme = theme
    }
}
