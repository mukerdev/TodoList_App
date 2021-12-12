//
//  TodoCell.swift
//  TodoList_App
//
//  Created by Muker on 2021/11/08.
//

import UIKit

class TodoCell: UITableViewCell {

    
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
