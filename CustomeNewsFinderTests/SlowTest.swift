import XCTest
@testable import CustomeNewsFinder

class FakesMapper: MapNewsToObject {
    func map(_ news: News) -> [ObjectNewsData?] {
        // Вернуть фейковые данные для тестирования
        let objectNewsData = ObjectNewsData(author: "fake autor",title: "fake")
        return [objectNewsData]
    }
}




class FakeRequestBuilder: RequestBuilder {
    func createRequestFrom(url: String, params: [String: String]) -> URLRequest? {
        // Вернуть фейковый URLRequest для тестирования
        let fakeURL = URL(string: "https://example.com/fake-request")!
        let request = URLRequest(url: fakeURL)
        return request
    }
}

class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    
    override func setUp() {
        super.setUp()
        let mapper = FakesMapper()
        let requestBuilder = FakeRequestBuilder()
        networkManager = NetworkManagerImpl(mapper: mapper, requestBilder: requestBuilder)
    }
    
    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }
    
    func testSendRequestForNews() {
        // Given
        let expectation = XCTestExpectation(description: "Retrieve news data")
        let theme = "technology"
        let page = 1
        
        // When
        networkManager.sendRequestForNews(theme: theme, page: page) { newsData in
            // Then
            XCTAssertNotNil(newsData)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLoadImage() {
        // Given
        let expectation = XCTestExpectation(description: "Load image")
        let imageUrl = "https://picsum.photos/536/354"
        
        // When
        networkManager.loadImage(urlForImage: imageUrl) { image in
            // Then
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
