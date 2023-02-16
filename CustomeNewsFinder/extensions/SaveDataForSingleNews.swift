class SaveDataForSingleNews: Codable {

    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
    init(title: String?, url: String?, publishedAt: String?, description: String?, author: String?, urlToImage: String?) {
        self.title = title
        self.url = url
        self.publishedAt = publishedAt
        self.description = description
        self.author = author
        self.urlToImage = urlToImage
    }
    
    public enum CodingKeys: String, CodingKey { // делаем ключи
        case author, title, description, url, urlToImage, publishedAt, content
    }
    
    required public init(from decoder: Decoder) throws {  //распаковываем
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = try container.decodeIfPresent(String.self, forKey: .author) // контайнер достаньстроку по ключу name и запиши в self.name
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)  // для опционалов decodeIfPresent
        self.urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        self.publishedAt = try container.decodeIfPresent(String.self, forKey: .publishedAt)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
    }
    
    public func encode(to encoder: Encoder) throws { //упаковываем все проперти в контейнер
        var container = encoder.container(keyedBy: CodingKeys.self) //создаём контэйнер
        try container.encode(self.author, forKey: .author) //отдельно свойство(проперти) упаковываем
        try container.encode(self.title, forKey: .title)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.url, forKey: .url)
        try container.encode(self.urlToImage, forKey: .urlToImage)
        try container.encode(self.publishedAt, forKey: .publishedAt)
        try container.encode(self.content, forKey: .content)
    }
    
}
