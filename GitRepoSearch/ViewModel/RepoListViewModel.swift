//
//  RepoListViewModel.swift
//  GitRepoSearch
//
//  Created by Bhalodiya, Keyur Ratilal | Kb | ECMPD on 2022/10/24.
//

import Foundation

final class RepositoriesFeedViewModel: ListViewModel {
    
    enum Section {
        case repositoriesFeed
    }
    
    enum Row {
        case repositoriesFeed(Item)
    }
    
    struct RepositoriesFeedSectionModel: SectionModel {
        var type: Section
        var rows: [Row]
    }
    
    private let dataProvider: DataProvider
    /// recent search keyword
    private var recentSeachText: String = ""
    /// page index used in api request param
    private(set) var pageIndex: Int = 1
    /// determine to used api needs to call when user scroll the list.
    /// set `true` once all app receive all records for specifc search keyword
    private(set) var shouldFinishLoading : Bool = false
    
    var sectionModels = [RepositoriesFeedSectionModel]()
    
    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
        
    /// API call to fetch repositories
    /// - Parameter searchText: search keyword
    /// - Parameter completion: will be success or fail
    func searchRepositoriesFeed(searchText: String, completion: @escaping((Bool) -> Void)) {
        guard !searchText.isEmpty else {
            sectionModels.removeAll()
            completion(true)
            return
        }
        
        resetPageIndexIfNeeded(searchText: searchText)
        dataProvider.fetchGitHubRepo(query: searchText, page: pageIndex) { [weak self] result in
            var isSuccess: Bool = false
            switch result {
            case .success(let repoSearchResult):
                self?.pageIndex += 1
                self?.generateSectionModels(items: repoSearchResult.items)
                self?.shouldFinishLoading = (self?.numberOfRows(for: .repositoriesFeed))! >= repoSearchResult.totalCount ?? 0
                isSuccess = true
            case .failure(_): break
            }
            completion(isSuccess)
        }
    }
    
    /// reset `pageIndex` `shouldFinishLoading` when user search repo with new keyword or empty text
    private func resetPageIndexIfNeeded(searchText: String) {
        if recentSeachText != searchText || searchText.isEmpty {
            pageIndex = 1
            shouldFinishLoading = false
            sectionModels.removeAll()
        }
        recentSeachText = searchText
    }
    
    private func generateSectionModels(items: [Item]?) {
        guard let repositoriesFeedSectionModel = repositoriesFeedSectionModel(items: items) else { return }
        sectionModels.removeAll()
        sectionModels.append(repositoriesFeedSectionModel)
    }
    
    private func repositoriesFeedSectionModel(items: [Item]?) -> RepositoriesFeedSectionModel? {
        let sectionModel = sectionModel(for: .repositoriesFeed)
        guard let rows = repositoriesRows(items: items) else {
            return sectionModel
        }
        
        if var model = sectionModel {
            model.rows.append(contentsOf: rows)
            return model
        } else {
            return RepositoriesFeedSectionModel(type: .repositoriesFeed, rows: rows)
        }
    }
    
    private func repositoriesRows(items: [Item]?) -> [Row]? {
        guard let items = items, !items.isEmpty else {
            return nil
        }
        return items.map({ Row.repositoriesFeed($0) })
    }
}

// MARK: - CollectionViewModel
extension RepositoriesFeedViewModel {
    
    func sectionModel(at section: Int) -> RepositoriesFeedSectionModel? {
        guard section >= 0, section < sectionModels.count else {
            return nil
        }
        return sectionModels[section]
    }
    
    func sectionModel(for type: Section) -> RepositoriesFeedSectionModel? {
        return sectionModels.first(where: { $0.type == type })
    }
    
    func row(at indexPath: IndexPath) -> Row? {
        guard indexPath.section < sectionModels.count else {
            return nil
        }
        let section = sectionModels[indexPath.section]
        guard indexPath.row < section.rows.count else {
            return nil
        }
        return section.rows[indexPath.row]
    }
}

