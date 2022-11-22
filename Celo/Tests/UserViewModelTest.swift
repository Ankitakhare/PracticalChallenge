//
//  TestUserViewModel.swift
//  CeloUnitTest
//
//  Created by ankita khare on 16/11/22.
//

import XCTest
@testable import Celo

final class UserViewModelTest: XCTestCase {
    
//    let userModel = UserModel(dict: [String : Any])

    var viewModel: UserViewModel?
    var apiManager: MockApiManager!
    
    override func setUp() {
        apiManager = MockApiManager()
        viewModel = UserViewModel(apiManager: apiManager)
    }
    
    func testGetUserData() {
        let expectation = XCTestExpectation(description: "Get User Data")
        apiManager.stubbedApiToGetUserDataCompletionResult = ([], nil)
        viewModel?.apiToGetUserData(page: 0, completion: {
            expectation.fulfill()
        })
        XCTAssertEqual(apiManager.invokedApiToGetUserDataCount, 1)
        XCTAssertEqual(apiManager.invokedApiToGetUserDataParameters?.page, 0)
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testGetUserDataFailure() {
        let expectation = XCTestExpectation(description: "Get User Data")
        apiManager.stubbedApiToGetUserDataCompletionResult = (nil, APIError.responseInvalid)
        viewModel?.apiToGetUserData(page: 0, completion: {
            expectation.fulfill()
        })
        XCTAssertEqual(apiManager.invokedApiToGetUserDataCount, 1)
        XCTAssertEqual(apiManager.invokedApiToGetUserDataParameters?.page, 0)
        wait(for: [expectation], timeout: 2.0)
    }
    
}
