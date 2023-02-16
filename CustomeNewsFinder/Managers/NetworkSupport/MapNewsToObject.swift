//
//  MapNewsToObject.swift
//  lub-ios-alexdok
//
//  Created by алексей ганзицкий on 04.02.2023.
//

import Foundation

protocol MapNewsToObject {
    func map(_ news: News) -> [ObjectNewsData?]
}

struct MapNewsToObjectImpl: MapNewsToObject {
    func map(_ news: News) -> [ObjectNewsData?] {
        var newObjectNewsAraay: [ObjectNewsData] = []
        for items in news.articles {
            let objectNews = ObjectNewsData(author: items.author,
                                            title: items.title,
                                            description: items.description,
                                            url: items.url,
                                            urlToImage: items.urlToImage,
                                            publishedAt: items.publishedAt,
                                            content: items.content)
                newObjectNewsAraay.append(objectNews)
        }
        return newObjectNewsAraay
    }
}

