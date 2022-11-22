//
//  MockApiManager.swift
//  Celo
//
//  Created by ankita khare on 16/11/22.
//

@testable import Celo

class MockApiManager: ApiManagerProtocol {

    var invokedApiToGetUserData = false
    var invokedApiToGetUserDataCount = 0
    var invokedApiToGetUserDataParameters: (page: Int, Void)?
    var invokedApiToGetUserDataParametersList = [(page: Int, Void)]()
    var stubbedApiToGetUserDataCompletionResult: ([UserModel]?, Error?)?

    func apiToGetUserData(page: Int, completion : @escaping ([UserModel]?, Error?) -> ()) {
        invokedApiToGetUserData = true
        invokedApiToGetUserDataCount += 1
        invokedApiToGetUserDataParameters = (page, ())
        invokedApiToGetUserDataParametersList.append((page, ()))
        if let result = stubbedApiToGetUserDataCompletionResult {
            completion(result.0, result.1)
        }
    }
}
