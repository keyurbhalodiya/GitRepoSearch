//
//  MockDataProvider.swift
//  GitRepoSearchTests
//
//  Created by Bhalodiya, Keyur Ratilal | Kb | ECMPD on 2022/10/25.
//

import XCTest
@testable import GitRepoSearch

final class MockDataProvider: DataProvider {

    var searchResult: RepoSearchResult?
    var error: ErrorResult?
    
    override func fetchGitHubRepo(query: String, page: Int, completion: @escaping ((Result<RepoSearchResult, ErrorResult>) -> Void)) {
        if let searchResult = searchResult {
            completion(.success(searchResult))
        } else if let error = error {
            completion(.failure(error))
        }
    }
}
