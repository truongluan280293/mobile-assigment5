//
//  FileTableCell.swift
//  rta-assigment5
//
//  Created by Truong Luan on 2/22/23.
//

import UIKit

class FileTableCell: UITableViewCell {

    @IBOutlet weak var fileName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(file: FileModel) {
        fileName.text = file.name
    }

}
