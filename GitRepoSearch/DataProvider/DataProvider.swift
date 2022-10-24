//
//  DataProvider.swift
//  GitRepoSearch
//
//  Created by Bhalodiya, Keyur Ratilal | Kb | ECMPD on 2022/10/24.
//

import Foundation

class DataProvider: NetworkHandler {
    
    /// Singleton class object
    public static let shared = DataProvider()
    
    var task: URLSessionTask?
    
    
    /// Generate task to search repo base on search keyword
    /// - Parameter completion: repo search result or error.
    func fetchGitHubRepo(query: String, page: Int, completion: @escaping ((Result<RepoSearchResult, ErrorResult>) -> Void)) {
        self.cancelFetchService()
        let parameters: [String: String] = [
            "q": query,
            "page": "\(page)"
        ]
        task = NetworkService().loadData(urlString: APIConstants.gitHubRepoSearch, parameters: parameters, completion: self.networkResult(completion: completion))
    }
    
    /// Cancel session task.
    func cancelFetchService() {
        if let task = task {
            task.cancel()
        }
        task = nil
    }
}
