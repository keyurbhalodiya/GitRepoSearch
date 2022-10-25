//
//  RepoListViewController.swift
//  GitRepoSearch
//
//  Created by Bhalodiya, Keyur Ratilal | Kb | ECMPD on 2022/10/24.
//

import UIKit
import Combine

final class RepoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    private enum Constant {
        static let repoItemCell = "RepoItemCell"
        static let searchDelay = 700
    }
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var searchBar: UISearchBar?
    @IBOutlet weak var messageLabel: UILabel?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    private let viewModel = RepoListViewModel(dataProvider: DataProvider())
    private var subscriptions = Set<AnyCancellable>()
    private var isLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateUIElements()
    }
    
    private func setupTableView() {
        tableView?.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        tableView?.register(UINib(nibName: Constant.repoItemCell,
                                      bundle: nil),
                           forCellReuseIdentifier: Constant.repoItemCell)
    }
    
    private func setupSearchBarListeners() {
        let publisher = NotificationCenter.default
            .publisher(for: UISearchTextField.textDidChangeNotification,
                       object: searchBar?.searchTextField)
        publisher
            .map {
                ($0.object as? UISearchTextField)?.text ?? ""
            }
            .debounce(for: .milliseconds(Constant.searchDelay), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] (searchText) in
                self?.searchRepositories(searchText: searchText)
            }
            .store(in: &subscriptions)
    }
    
    private func searchRepositories(searchText: String) {
        guard !isLoading else { return }
        activityIndicator?.startAnimating()
        isLoading = true
        viewModel.searchRepositoriesFeed(searchText: searchText) { [weak self] isSuccess in
            self?.updateUIElements(isSuccess: isSuccess)
        }
    }
    
    private func updateUIElements(isSuccess: Bool = true) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.activityIndicator?.stopAnimating()
            self.tableView?.isHidden = self.viewModel.sectionModels.isEmpty
            self.messageLabel?.isHidden = !self.viewModel.sectionModels.isEmpty
            self.tableView?.reloadData()
            if !isSuccess {
                self.showAlert(title: APIConstants.error, message: APIConstants.errorMessage)
            }
        }
    }
}


// MARK: - UITableViewDataSource
extension RepoListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rowCount = viewModel.sectionModel(at: section)?.rows.count else {
            return 0
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = viewModel.row(at: indexPath) else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.repoItemCell, for: indexPath)
        
        switch row {
        case .repositoriesFeed(let item):
            if let cell = cell as? RepoItemCell {
                cell.style(with: item)
                cell.linkTapHandler = { tag in
                    let urlString = tag == 1 ? item.htmlURL : item.owner?.htmlURL
                    guard let url = URL(string: urlString ?? "") else { return }
                    UIApplication.shared.open(url)
                }
            }
        }
        
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension RepoListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !viewModel.shouldFinishLoading) {
            searchRepositories(searchText: searchBar?.text ?? "")
        }
    }
    
    func searchBarSearchButtonClicked(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
