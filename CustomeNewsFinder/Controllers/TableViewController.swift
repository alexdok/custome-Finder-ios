//
//  ViewController.swift
//  CustomeNewsFinder
//
//  Created by алексей ганзицкий on 09.02.2023.
//

import UIKit

final class TableViewController: UIViewController, UISearchBarDelegate {
    
    var viewModel: TableViewModel?
    let tableNews = UITableView()
    let refreshControl = UIRefreshControl()
    let searchBar = UISearchBar()
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshController()
        bind()
        configureVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func bind() {
        viewModel?.newsObjectData.bind({ [weak self] object in
            self?.viewModel?.data = object
            self?.tableNews.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if self?.viewModel?.data == nil || self?.viewModel?.data?.count ?? 0 == 0  {
                    self?.navigationItem.title = "Bad Connection"
                } else {
                    self?.navigationItem.title = "Table News"
                }
            }
        })
    }
    
    func setupRefreshController() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableNews.addSubview(refreshControl)
    }
    
    func configureTableNews() {
        tableNews.rowHeight = 150
        tableNews.estimatedRowHeight = 150
        tableNews.dataSource = self
        tableNews.delegate = self
        tableNews.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsTableViewCell")
    }
    
    func configureVC() {
        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        viewModel?.viewIsready()
        createTableNews()
        configureTableNews()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel?.reloadData()
        refreshControl.endRefreshing()
    }
}

extension TableViewController {
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel?.theme = searchBar.searchTextField.text ?? "main"
        reloadTableNews()
        searchBar.searchTextField.text = nil
    }
    
    private func reloadTableNews() {
        viewModel?.reloadData()
        tableNews.reloadData()
        if viewModel?.data?.count ?? 0 > 1 {
            let indexPath = IndexPath(row: 0, section: 0)
            tableNews.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        bottomConstraint?.constant = -keyboardHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        bottomConstraint?.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
        bottomConstraint?.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension TableViewController {
    // MARK: - set constraints
    func createTableNews() {
        view.addSubview(tableNews)
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        tableNews.translatesAutoresizingMaskIntoConstraints = false
        
        bottomConstraint = searchBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            tableNews.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableNews.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableNews.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableNews.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
