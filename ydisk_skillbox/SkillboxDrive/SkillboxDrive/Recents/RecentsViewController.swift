//
//  RecentsViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 19.04.2023.
//

import UIKit

class RecentsViewController: UITableViewController {
    
    // MARK: - Public Properties
    var token: String?
    
    // MARK: - Private Properties
    private var response: Response?
    
//    private var spinnerView = UIActivityIndicatorView()

    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
//        showSpinner(in: view)

        fetchData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    // MARK: - UIActivityIndicatorView
//    private func showSpinner(in view: UIView) {
//        spinnerView = UIActivityIndicatorView(style: .large)
//        spinnerView.color = .gray
//        spinnerView.startAnimating()
//        spinnerView.center = view.center
//        spinnerView.hidesWhenStopped = true
//
//        view.addSubview(spinnerView)
//    }
    
    // MARK: - Networking
    private func fetchData() {
        NetworkManager.shared.fetchData(from: Link.url.rawValue, with: token) { [weak self] result in
            switch result {
            case .success(let response):
                print("Received: \(response.items?.count ?? 0) files")
                self?.response = response
                self?.tableView.reloadData()
//                self?.spinnerView.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
}
