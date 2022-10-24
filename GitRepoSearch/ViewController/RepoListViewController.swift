//
//  RepoListViewController.swift
//  GitRepoSearch
//
//  Created by Bhalodiya, Keyur Ratilal | Kb | ECMPD on 2022/10/24.
//

import UIKit

final class RepoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    private enum Constant {
        static let repoItemCell = "RepoItemCell"
        static let searchDelay = 700
    }
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var searchBar: UISearchBar?
    @IBOutlet weak var messageLabel: UILabel?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
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
    
    private func updateUIElements(isSuccess: Bool = true) {
    
    }
}


// MARK: - UITableViewDataSource
extension RepoListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension RepoListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
