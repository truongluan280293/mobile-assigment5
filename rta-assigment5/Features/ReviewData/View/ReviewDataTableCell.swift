//
//  ReviewDataTableCell.swift
//  rta-assigment5
//
//  Created by Truong Luan on 2/22/23.
//

import UIKit

class ReviewDataTableCell: UITableViewCell {

    @IBOutlet weak var nameFileLabel: UILabel!
    @IBOutlet weak var instanceIDLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let selectView = UIView()
        selectView.backgroundColor = .clear
        selectedBackgroundView = selectView
        // Configure the view for the selected state
    }

    
    func setData(model: InstanceIDModel) {
        nameFileLabel.text = model.fileInfo.name
        instanceIDLabel.text = model.id
    }
}
