//
//  PublishedViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 22.05.2023.
//

import UIKit

class PublishedViewController: UITableViewController {

    // MARK: - IB Outlets
    @IBOutlet var alertView: UIView!
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    // MARK: - Private Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 25
        let imageView = UIImageView(image: UIImage(named: "EmptyFolder"))
        stackView.addArrangedSubview(imageView)
        let label = UILabel()
        label.text = "The directory doesn't contain files"
        label.font = UIFont(name: "Graphik-Regular", size: 17)
        label.textAlignment = .center
        label.numberOfLines = 2
        stackView.addArrangedSubview(label)
        return stackView
    }()
    
    private var viewModel: PublishedViewModelProtocol! {
        didSet {
            viewModel.fetchItems { [weak self] in
                self?.updateUI()
                self?.activityIndicator.stopAnimating()
            }
            viewModel.deleteButtonWasPressed = { [weak self] viewModel in
                self?.showDeleteAlert(to: viewModel)
            }
        }
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PublishedViewModel()
        setupUI()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "publishedItem", for: indexPath)
        guard let cell = cell as? PublishedItemCell else { return UITableViewCell() }
        cell.viewModel = viewModel.getPublishedItemCellViewModel(at: indexPath)
        cell.delegate = viewModel as PublishedItemCellDelegate
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        viewModel.fetchExtraItems(afterRowAt: indexPath) { [weak self] in
            self?.updateUI()
        }
    }
    
    // MARK: - IB Actions
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        tableView.separatorStyle = .none
        tableView.refreshControl?.addTarget(
            self,
            action: #selector(refresh(sender:)),
            for: .valueChanged
        )
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
        tableView.reloadData()
        viewModel.checkDirectory {
            setupBackgroundView()
        }
    }
    
    private func setupBackgroundView() {
        let contentView = UIView()
        tableView.backgroundView = contentView
        contentView.addSubview(stackView)
        
        // TODO: - Add button
        
        setupConstraints(on: contentView)
    }
    
    private func setupConstraints(on view: UIView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                           constant: -20).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    // MARK: - Alert Controllers
    private func showDeleteAlert(to item: PublishedItemCellViewModelProtocol) {
        let alert = UIAlertController(title: item.name, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] _ in
            viewModel.deletePublished(item) { [weak self] in
                self?.viewModel.fetchItems {
                    self?.updateUI()
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
}
