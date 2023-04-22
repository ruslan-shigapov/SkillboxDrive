//
//  RecentsViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 19.04.2023.
//

import UIKit
import Kingfisher

class RecentsViewController: UITableViewController {
    
    // MARK: - Public Properties
    var token: String?
    
    // MARK: - Private Properties
    private var response: Response?
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        response?.items?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        guard let cell = cell as? ItemCell else { return UITableViewCell() }
        if let item = response?.items?[indexPath.row] {
            cell.configure(with: item)
        }
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Networking
    private func fetchData() {
        NetworkManager.shared.fetchData(from: Link.url.rawValue, with: token) { [weak self] result in
            switch result {
            case .success(let response):
                print("Received: \(response.items?.count ?? 0) files")
                self?.response = response
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
