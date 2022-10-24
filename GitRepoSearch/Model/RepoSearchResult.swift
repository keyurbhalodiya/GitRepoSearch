//
//  RepoSearchResult.swift
//  GitRepoSearch
//
//  Created by Bhalodiya, Keyur Ratilal | Kb | ECMPD on 2022/10/24.
//

import Foundation

// MARK: - RepoSearchResult
struct RepoSearchResult: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [Item]?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

// MARK: - Item
struct Item: Codable {
    let id: Int?
    let fullName: String?
    let owner: Owner?
    let htmlURL: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case owner
        case htmlURL = "html_url"
        case description
    }
}

// MARK: - Owner
struct Owner: Codable {
    let id: Int?
    let avatarURL: String?
    let htmlURL: String?
    let login: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case login
    }
}
