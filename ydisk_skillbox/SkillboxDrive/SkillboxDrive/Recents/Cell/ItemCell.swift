//
//  ItemCell.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 22.04.2023.
//

import UIKit
import Kingfisher

class ItemCell: UITableViewCell {

    @IBOutlet var iconView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!

    func configure(with item: Item) {
        nameLabel.text = item.name
        infoLabel.text = item.information
        guard let icon = item.preview else {
            iconView.image = UIImage(named: "Folder")
            return
        }
        guard let imageURL = URL(string: icon) else { return }
        iconView.kf.setImage(with: imageURL) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.lastPathComponent ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}
