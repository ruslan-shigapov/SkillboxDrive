//
//  BrowseViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 30.04.2023.
//

import UIKit

class BrowseViewController: UITableViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var alertView: UIView!
    
    // MARK: - Private Properties
    private var viewModel: BrowseViewModelProtocol! {
        didSet {
            viewModel.fetchItems { [weak self] isConnected in
                self?.updateUI(isConnected)
            }
        }
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BrowseViewModel()
        tableView.separatorStyle = .none
        tableView.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.fetchExtraItems(afterRowAt: indexPath) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Private Methods
    @objc private func refresh(sender: UIRefreshControl) {
        viewModel.fetchItems { [weak self] isConnected in
            self?.updateUI(isConnected)
            sender.endRefreshing()
        }
    }
    
    private func updateUI(_ isConnected: Bool) {
        alertView.frame.size.height = isConnected ? 0 : 40
        alertView.isHidden = isConnected ? true : false
        tableView.reloadData()
    }
}
