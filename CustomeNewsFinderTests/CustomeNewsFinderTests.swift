//
//  CustomeNewsFinderTests.swift
//  CustomeNewsFinderTests
//
//  Created by алексей ганзицкий on 10.07.2023.
//

import XCTest
@testable import CustomeNewsFinder

final class CustomeNewsFinderTests: XCTestCase {
    var sut: TableViewModel!
    
    override func setUpWithError() throws {
       try super.setUpWithError()
        sut = TableViewModel(networkManager: FakeNetworkManager())
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testloadNewPageNews() {
        // given
        let page = sut.page + 1

        // when
        sut.loadNewPageNews()

        // then
        XCTAssertEqual(page, sut.page, "page is not next")
    }


}
