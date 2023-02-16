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
        var test = 0
        
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
            let urlObj = "\(urlForImage)"
            if let image = cacheDataSource.object(forKey: urlForImage as AnyObject) {
                completion(image)
    
            } else {
                guard let urlImage = URL(string: urlObj) else {
                    return
                }
                let session = URLSession(configuration: .default)
                let request = URLRequest(url: urlImage, cachePolicy: .returnCacheDataElseLoad)
                let task = session.dataTask(with: request) { (data, response, error) in
                    if let data = data, error == nil {
                        guard let image = UIImage(data: data) else { return }
                        self.cacheDataSource.setObject(image, forKey: urlForImage as AnyObject)
                        image.jpegData(compressionQuality: 0.3)
                        completion(image)
                    }
                }
                task.resume()
            }
        }
        
        private func createParamsForRequest(theme: String, keyAPI: String, page: Int) -> [String: String] {
            let pageToString = String(page)
            let date = NSDate()
            let formater = DateFormatter()
            formater.dateFormat = "yyyy-MM-dd"
            
            let URLParams = [
                "q": theme,
                "status": "ok",
                "language": "en",
                "pageSize": "20",
                "page": pageToString,
                "from":  formater.string(from: date as Date),
                "sortBy": "popularity",
                "apiKey": keyAPI
            ]
            return URLParams
        }
    }

    private extension NetworkManagerImpl {
        enum Constants {
            static let url = "https://newsapi.org/v2/everything"
            static let apiKey = "e32a02b0b4ca4c49aea6c97506f25524"
            
        }
    }

class fakeNetworkManager: NetworkManager {
    func sendRequestForNews(theme: String, page: Int, completion: @escaping ([ObjectNewsData?]) -> Void) {
        completion([nil])
    }
    
    func loadImage(urlForImage: String, completion: @escaping (UIImage) -> Void) {

    }
    
    
}







