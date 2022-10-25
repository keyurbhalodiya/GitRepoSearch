//
//  RepoListViewModelTests.swift
//  GitRepoSearchTests
//
//  Created by Bhalodiya, Keyur Ratilal | Kb | ECMPD on 2022/10/25.
//

import XCTest
@testable import GitRepoSearch

final class RepositoriesFeedViewModelTests: XCTestCase {

    var viewModel: RepoListViewModel!
    var mockDataProvider: MockDataProvider!
    
    override func setUp() {
        mockDataProvider = MockDataProvider()
        viewModel = RepoListViewModel(dataProvider: mockDataProvider)
    }
    
    func testEmptySectionModels() {
        XCTAssertEqual(viewModel.numberOfSections, 0)
        XCTAssertNil(viewModel.sectionModel(at: 0))
        XCTAssertNil(viewModel.sectionModel(for: .repositoriesFeed))
        XCTAssertNil(viewModel.row(at: IndexPath(row: 0, section: 0)))
        XCTAssertEqual(viewModel.numberOfRows(for: .repositoriesFeed), 0)
        XCTAssertEqual(viewModel.numberOfRows(in: 0), 0)
    }

    func testLoadDataForSearchKeyword() throws {
        mockDataProvider.searchResult = TestHelper.loadSearchRepoData(filename: "SearchResult_1")
        viewModel.searchRepositoriesFeed(searchText: "sdwebimage") { _ in }
        
        XCTAssertEqual(self.viewModel.numberOfSections, 1)
        XCTAssertNotNil(viewModel.sectionModel(at: 0))
        XCTAssertNotNil(viewModel.sectionModel(for: .repositoriesFeed))
        XCTAssertNotNil(viewModel.row(at: IndexPath(row: 0, section: 0)))
        XCTAssertNil(viewModel.row(at: IndexPath(row: 100, section: 0)))
        XCTAssertEqual(viewModel.numberOfRows(for: .repositoriesFeed), 2)
        XCTAssertEqual(viewModel.numberOfRows(in: 0), 2)
        
        XCTAssertFalse(viewModel.shouldFinishLoading)
        XCTAssertEqual(viewModel.pageIndex, 2)
        
        /// Verify `RepositoriesFeedCellModel` properties
        let row = self.viewModel.row(at: IndexPath(row: 0, section: 0))
        if case .repositoriesFeed(let cellModel) = row {
            // verify row property
            XCTAssertEqual(cellModel.fullName, "SDWebImage/SDWebImage")
            XCTAssertEqual(cellModel.description, "Asynchronous image downloader with cache support as a UIImageView category")
            XCTAssertEqual(cellModel.htmlURL, "https://github.com/SDWebImage/SDWebImage")
            XCTAssertEqual(cellModel.owner?.login, "SDWebImage")
            XCTAssertEqual(cellModel.owner?.htmlURL, "https://github.com/SDWebImage")
            XCTAssertEqual(cellModel.owner?.avatarURL, "https://avatars.githubusercontent.com/u/33113626?v=4")
        } else {
            XCTExpectFailure()
        }
    }
    
    func testNextPageLoadDataForSearchKeyword() throws {
        // 1st page call
        mockDataProvider.searchResult = TestHelper.loadSearchRepoData(filename: "SearchResult_1")
        viewModel.searchRepositoriesFeed(searchText: "sdwebimage") { _ in }
        
        XCTAssertFalse(viewModel.shouldFinishLoading)
        XCTAssertEqual(viewModel.pageIndex, 2)
        
        // 2nd page call
        mockDataProvider.searchResult = TestHelper.loadSearchRepoData(filename: "SearchResult_2")
        viewModel.searchRepositoriesFeed(searchText: "sdwebimage") { _ in }

        XCTAssertTrue(viewModel.shouldFinishLoading)
        XCTAssertEqual(viewModel.pageIndex, 3)
        XCTAssertEqual(viewModel.numberOfRows(in: 0), 4)
        XCTAssertEqual(viewModel.numberOfRows(for: .repositoriesFeed), 4)
    }
    
    func testChangeSearchKeywordData() throws {
        // 1st page call
        mockDataProvider.searchResult = TestHelper.loadSearchRepoData(filename: "SearchResult_1")
        viewModel.searchRepositoriesFeed(searchText: "sdwebimage") { _ in }
        // 2nd page call
        mockDataProvider.searchResult = TestHelper.loadSearchRepoData(filename: "SearchResult_2")
        viewModel.searchRepositoriesFeed(searchText: "sdwebimage") { _ in }
        XCTAssertTrue(viewModel.shouldFinishLoading)
        XCTAssertEqual(viewModel.pageIndex, 3)
        XCTAssertEqual(viewModel.numberOfRows(for: .repositoriesFeed), 4)
        
        mockDataProvider.searchResult = TestHelper.loadSearchRepoData(filename: "SearchResult_3")
        viewModel.searchRepositoriesFeed(searchText: "Alamofire") { _ in }
        XCTAssertFalse(viewModel.shouldFinishLoading)
        XCTAssertEqual(viewModel.pageIndex, 2)
        XCTAssertEqual(viewModel.numberOfRows(for: .repositoriesFeed), 1)
    }
    
    func testEmptySearchKeywordData() throws {
        // 1st page call
        mockDataProvider.searchResult = TestHelper.loadSearchRepoData(filename: "SearchResult_4")
        viewModel.searchRepositoriesFeed(searchText: "iqkeyboard") { _ in }
        XCTAssertEqual(viewModel.numberOfSections, 0)
    }
    
    func testSearchKeywordDataEmpty() throws {
        // 1st page call
        mockDataProvider.searchResult = TestHelper.loadSearchRepoData(filename: "SearchResult_1")
        viewModel.searchRepositoriesFeed(searchText: "sdwebimage") { _ in }
        // 2nd page call
        mockDataProvider.searchResult = TestHelper.loadSearchRepoData(filename: "SearchResult_2")
        viewModel.searchRepositoriesFeed(searchText: "") { _ in }
        XCTAssertEqual(viewModel.numberOfSections, 0)
    }
}

enum TestHelper {
    public static func loadSearchRepoData(filename fileName: String) -> RepoSearchResult? {
        let bundle = Bundle(for: RepositoriesFeedViewModelTests.self)
        if let url = bundle.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let repoSearch = try decoder.decode(RepoSearchResult.self, from: data)
                return repoSearch
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}

