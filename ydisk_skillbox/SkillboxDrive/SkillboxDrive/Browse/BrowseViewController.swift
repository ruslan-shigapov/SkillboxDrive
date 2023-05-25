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
    @IBOutlet var backButton: UIBarButtonItem!
    
    // MARK: - Private Properties
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
        label.text = Constants.Text.emptyDirectory
        label.font = UIFont(name: "Graphik-Regular", size: 17)
        label.textAlignment = .center
        label.numberOfLines = 2
        stackView.addArrangedSubview(label)
        return stackView
    }()
    
    private var viewModel: BrowseViewModelProtocol! {
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
        viewModel = BrowseViewModel()
        setupUI()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsViewController = segue.destination as? DetailsViewController else {
            return
        }
        detailsViewController.viewModel = sender as? DetailsViewModelProtocol
        detailsViewController.delegate = viewModel as DetailsViewControllerDelegate
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        guard let cell = cell as? ItemCell else { return UITableViewCell() }
        cell.viewModel = viewModel.getItemCellViewModel(at: indexPath)
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsViewModel = viewModel.getDetailsViewModel(at: indexPath)
        viewModel.checkTransition(by: detailsViewModel) { isFile in
            if isFile {
                performSegue(withIdentifier: "toDetails", sender: detailsViewModel)
            } else {
                tableView.backgroundView = activityIndicator
                viewModel.fetchItems { [weak self] in
                    self?.backButton.tintColor = .systemGray
                    self?.updateUI()
                }
            }
        }
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
        viewModel.goToBackScreen {
            tableView.backgroundView = activityIndicator
            viewModel.fetchItems { [weak self] in
                self?.updateUI()
            }
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backButton.tintColor = .white
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
        activityIndicator.stopAnimating()
        tableView.reloadData()
        viewModel.checkRootDirectory {
            backButton.tintColor = .white
        }
        viewModel.checkDirectory {
            setupBackgroundView()
        }
    }
    
    private func setupBackgroundView() {
        let contentView = UIView()
        tableView.backgroundView = contentView
        contentView.addSubview(stackView)
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
}
