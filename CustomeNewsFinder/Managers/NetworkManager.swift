//
//  NetworkManager.swift
//  CustomeNewsFinder
//
//  Created by алексей ганзицкий on 09.02.2023.
//

import Foundation
import UIKit

protocol NetworkManager {
    func sendRequestForNews( theme: String, page: Int, completion: @escaping ([ObjectNewsData?]) -> Void)
    func loadImage(urlForImage: String, completion: @escaping (UIImage) -> Void)
}

class NetworkManagerImpl: NetworkManager {
    
    private let mapper: MapNewsToObject
    private let requestBilder: RequestBuilder
    lazy var cacheDataSource: NSCache<AnyObject, UIImage> = {
        let cache = NSCache<AnyObject, UIImage>()
        cache.countLimit = 15
        return cache
    }()
    
    init(mapper: MapNewsToObject, requestBilder: RequestBuilder) {
        self.mapper = mapper
        self.requestBilder = requestBilder
    }
    
    func sendRequestForNews( theme: String, page: Int, completion: @escaping ([ObjectNewsData?]) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let URLParams = createParamsForRequest(theme: theme, keyAPI: Constants.apiKey, page: page)
        guard let request = requestBilder.createRequestFrom(url: Constants.url, params: URLParams) else { return }
        
        let task = session.dataTask(with: request) { data, response, error in
            if error == nil, let data = data {
                do {
                    let news = try JSONDecoder().decode(News.self, from: data)
                    let objectNews = self.mapper.map(news)
                    completion(objectNews)
                } catch {
                    print(error)
                    let obj: [ObjectNewsData?] = [nil]
                    completion(obj)
                }
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func loadImage(urlForImage: String, completion: @escaping (UIImage) -> Void) {
        if let image = cacheDataSource.object(forKey: urlForImage as AnyObject) as? UIImage {
            // Изображение найдено в кэше
            completion(image)
        } else {
            guard let urlImage = URL(string: urlForImage) else {
                return
            }
            let session = URLSession(configuration: .default)
            let request = URLRequest(url: urlImage, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20)
            let task = session.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }

                if let data = data, error == nil {
                    guard let image = UIImage(data: data) else { return }

                    // Сохраняем загруженное изображение в кэше
                    self.cacheDataSource.setObject(image, forKey: urlForImage as AnyObject)

                    // Дополнительно: Вы можете сжать изображение перед сохранением в кэш, если это необходимо
                    // let compressedImage = image.jpegData(compressionQuality: 0.3)
                    // self.cacheDataSource.setObject(compressedImage as AnyObject, forKey: urlForImage as AnyObject)

                    completion(image)
                }
            }
            task.resume()
        }
    }

    private func createParamsForRequest(theme: String, keyAPI: String, page: Int) -> [String: String] {
        let pageToString = String(page)
        let dateForNews = convertCurrentDateToString()
        
        let URLParams = [
            "q": theme,
            "status": "ok",
            "language": "en",
            "pageSize": "20",
            "page": pageToString,
            "from": dateForNews,
            "sortBy": "popularity",
            "apiKey": keyAPI
        ]
        return URLParams
    }
}

private func convertCurrentDateToString() -> String {
    let date = NSDate()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd"
    let dayCurrent = formatter.string(from: date as Date)
    let theDayBefore = "-\(Int(dayCurrent)! - 1 )"
    formatter.dateFormat = "yyyy-MM"
    let newYearAndMonth = formatter.string(from: date as Date)
    let dateForNews = newYearAndMonth + theDayBefore
    return dateForNews
}

private extension NetworkManagerImpl {
    enum Constants {
        static let url = "https://newsapi.org/v2/everything"
        static let apiKey = "bd4291cebed94b898dd76406d634bac2"
    }
}

class FakeNetworkManager: NetworkManager {
    func sendRequestForNews(theme: String, page: Int, completion: @escaping ([ObjectNewsData?]) -> Void) {
        completion([nil])
    }
    func loadImage(urlForImage: String, completion: @escaping (UIImage) -> Void) {
    }
}







