//
//  PublishedViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 22.05.2023.
//

import UIKit

final class PublishedViewController: UITableViewController {
    
    @IBOutlet var alertView: UIView!
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 25
        let imageView = UIImageView(image: UIImage(named: "EmptyFolder"))
        stackView.addArrangedSubview(imageView)
        let label = UILabel()
        label.text = Constants.Text.emptyPublishedDirectory
        label.font = UIFont(name: "Graphik-Regular", size: 17)
        label.textAlignment = .center
        label.numberOfLines = 2
        stackView.addArrangedSubview(label)
        return stackView
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Text.refresh, for: .normal)
        button.titleLabel?.font = UIFont(name: "Graphik-Semibold", size: 16)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9608833194, green: 0.7450240254, blue: 0.7262871265, alpha: 1)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(updateData), for: .touchUpInside)
        return button
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PublishedViewModel()
        setupUI()
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
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
    
    @objc private func updateData() {
        tableView.backgroundView = activityIndicator
        viewModel.fetchItems { [weak self] in
            self?.updateUI()
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
        contentView.addSubview(refreshButton)
        setupConstraints(on: contentView)
    }
    
    private func setupConstraints(on view: UIView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: -20
            ),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 210),
            stackView.heightAnchor.constraint(equalToConstant: 205),
            refreshButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -92
            ),
            refreshButton.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.814249
            ),
            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            refreshButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - UITableView data source
extension PublishedViewController {
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.numberOfRows()
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "publishedItem",
            for: indexPath
        )
        guard let cell = cell as? PublishedItemCell else {
            return UITableViewCell()
        }
        cell.viewModel = viewModel.getPublishedItemCellViewModel(at: indexPath)
        cell.delegate = viewModel as PublishedItemCellDelegate
        return cell
    }
}

// MARK: - UITableView delegate
extension PublishedViewController {
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        viewModel.fetchExtraItems(afterRowAt: indexPath) { [weak self] in
            self?.updateUI()
        }
    }
}
 
// MARK: - UIAlertController
extension PublishedViewController {
    
    private func showDeleteAlert(to item: PublishedItemCellViewModelProtocol) {
        let alert = UIAlertController(
            title: item.name,
            message: nil,
            preferredStyle: .actionSheet
        )
        let cancelAction = UIAlertAction(
            title: Constants.Text.cancel,
            style: .cancel
        )
        let deleteAction = UIAlertAction(
            title: Constants.Text.deletePublication,
            style: .destructive
        ) { [unowned self] _ in
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
