//
//  ViewController+extension.swift
//  CustomeNewsFinder
//
//  Created by алексей ганзицкий on 12.02.2023.
//

import Foundation
import UIKit

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = viewModel?.data else { return 0}
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell else { print("fatalError(canot create cell)")
            return UITableViewCell()
        }
        
        guard let data = viewModel?.data else { return UITableViewCell() }
        if let dataCell = data[indexPath.row] {
            cellConfig(data: dataCell, cell: cell)
            loadNewCells(indexPath: indexPath, data: data)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    private func cellConfig(data: ObjectNewsData, cell: NewsTableViewCell) {
        cell.setLabelsCell(objectForCell: data)
        if let urlToImage = data.urlToImage {
            viewModel?.loadImage(linkToImageNews: urlToImage, completion: { image in
                DispatchQueue.main.async {
                    cell.setupImageCell(image: image )
                }
            })
        } else {
            cell.setupImageCell(image: UIImage(named: "noImage")!)
        }
    }
    
    private func loadNewCells(indexPath:IndexPath, data: [ObjectNewsData?]) {
        guard data.count > 5 else { return }
        if indexPath.row == data.count - 10 {
            viewModel?.loadNewData = true
        }
        guard let canNewLoad = viewModel?.loadNewData else { return }
        if indexPath.row >= data.count - 2  && canNewLoad {
            viewModel?.loadNewPageNews()
            viewModel?.loadNewData = false
            tableNews.reloadData()
        }
        if indexPath.row == data.count - 2 && canNewLoad == false && viewModel?.page != 1 {
            viewModel?.page = 0
            viewModel?.loadNewData = false
            viewModel?.loadNewPageNews()
            tableNews.reloadData()
        }
    }
}

extension TableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        takeDataToNewController(indexPath: indexPath)
        if let dataUrl = viewModel?.data?[indexPath.row]?.title {
            updateСlickСount(urlNews: dataUrl)
            tableNews.reloadData()
        }
    }
    
   private func takeDataToNewController(indexPath: IndexPath) {
        let controller = DetailViewController()
        controller.networkManager = viewModel?.networkManager
        guard let data = viewModel?.data else { return }
       
        if let objectForLoad = takeData(url: data[indexPath.row]?.url ?? "") {
            controller.setValuesForController(saveObjectForSingleNews: objectForLoad)
        } else {
            let saveObjectForSingleNews = createSaveClassObject(data: data, indexPath: indexPath)
            controller.setValuesForController(saveObjectForSingleNews: saveObjectForSingleNews)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
           let saveObjectForSingleNews = self.createSaveClassObject(data: data, indexPath: indexPath)
           controller.setValuesForController(saveObjectForSingleNews: saveObjectForSingleNews)
           controller.formatDate()
       }
        self.navigationController?.pushViewController(controller, animated: true)
    }

    private func createSaveClassObject(data: [ObjectNewsData?], indexPath: IndexPath) -> SaveDataForSingleNews? {
        guard let saveKey = data[indexPath.row]?.url else { return nil }
        let saveClassObject = SaveDataForSingleNews(title: data[indexPath.row]?.title,
                                                    url: data[indexPath.row]?.url,
                                                    publishedAt: data[indexPath.row]?.publishedAt,
                                                    description: data[indexPath.row]?.description,
                                                    author: data[indexPath.row]?.author,
                                                    urlToImage: data[indexPath.row]?.urlToImage )
        UserDefaults.standard.set(encodeble: saveClassObject, forKey: saveKey)
        return saveClassObject
    }
    
    private func takeData(url saveKey : String) -> SaveDataForSingleNews? {
        guard let loadValue = UserDefaults.standard.value(SaveDataForSingleNews.self, forKey: saveKey) else { return nil}
        return loadValue
    }
    
    private func updateСlickСount(urlNews key: String) {
        var counter = SaveManagerImpl.shared.loadCount(key)
        counter += 1
        SaveManagerImpl.shared.save(key, count: counter)
    }
}
