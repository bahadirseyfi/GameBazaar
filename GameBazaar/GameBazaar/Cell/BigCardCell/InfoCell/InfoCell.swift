//
//  InfoCell.swift
//  GameBazaar
//
//  Created by bahadir on 27.05.2021.
//

import UIKit

final class InfoCell: UITableViewCell {
    static let reuseIdentifier: String = "InfoCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func setupUI() {

    }
    
    func configure(infos: [String:String]){
        titleLabel.text = infos.keys.first
        detailLabel.text = infos.values.first
    }
}
