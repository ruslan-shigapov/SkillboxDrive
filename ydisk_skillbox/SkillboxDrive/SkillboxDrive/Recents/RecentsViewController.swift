//
//  RecentsViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 19.04.2023.
//

import UIKit

class RecentsViewController: UITableViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var alertView: UIView!
    
    // MARK: - Private Properties
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private var viewModel: RecentsViewModelProtocol! {
        didSet {
            viewModel.fetchItems { [weak self] in
                self?.updateUI()
            }
            viewModel.backButtonWasPressed = { [weak self] in
                self?.viewModel.fetchItems {
                    self?.updateUI()
                }
            }
        }
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RecentsViewModel()
        setupUI()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsViewController = segue.destination as? DetailsViewController else { return }
        detailsViewController.viewModel = sender as? DetailsViewModelProtocol
        detailsViewController.delegate = viewModel as DetailsViewControllerDelegate
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        guard let cell = cell as? ItemCell else { return UITableViewCell() }
        cell.viewModel = viewModel.getItemCellViewModel(at: indexPath)
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsViewModel = viewModel.getDetailsViewModel(at: indexPath)
        viewModel.checkTransition(by: detailsViewModel) {
            performSegue(withIdentifier: "toDetails", sender: detailsViewModel)
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        tableView.separatorStyle = .none
        tableView.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tableView.backgroundView = activityIndicator
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        viewModel.fetchItems { [weak self] in
            self?.updateUI()
            sender.endRefreshing()
        }
    }

    private func updateUI() {
        alertView.frame.size.height = viewModel.networkIsConnected ? 0 : 40
        alertView.isHidden = viewModel.networkIsConnected ? true : false
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }
}
