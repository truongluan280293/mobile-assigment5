//
//  ReviewDataViewController.swift
//  rta-assigment5
//
//  Created by Truong Luan on 2/22/23.
//

import UIKit
import PKHUD

class ReviewDataViewController: UIViewController {
    
    var arrInstanceId: [InstanceIDModel]?
    private var arrData: [InstanceIDModel] {
        return arrInstanceId ?? [InstanceIDModel]()
    }

    @IBOutlet weak var tableView: UITableView!
    
    var controller = ReviewDataControllerImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Review"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(tapSaveButton))
    }
    
    @objc func tapSaveButton() {
        controller.prepareImportation()
        
        let percentView = PKHUDProgressView(title: "Saving", subtitle: "0/100%")
        PKHUD.sharedHUD.contentView = percentView
        PKHUD.sharedHUD.show()
        
        controller.startImportation(instanceIds: arrData) { percent in
            print(percent)
            percentView.subtitleLabel.text = percent
        } completion: {
            PKHUD.sharedHUD.hide(true) { [weak self] _ in
                self?.dismiss(animated: true)
            }
        }
    }
    

}

extension ReviewDataViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewDataTableCell", for: indexPath)
        let model = arrData[indexPath.row]
        if let reviewCell = cell as? ReviewDataTableCell {
            reviewCell.setData(model: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fileInfo = arrData[indexPath.row].fileInfo
        let viewer = XMLContentViewController()
        viewer.filePath = fileInfo.path
        viewer.fileName = fileInfo.name
        let nav = UINavigationController(rootViewController: viewer)
        self.present(nav, animated: true)
    }
}
