//
//  OfficialFilesViewController.swift
//  rta-assigment5
//
//  Created by Truong Luan on 2/23/23.
//

import UIKit
import PKHUD

class OfficialFilesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var controller = OfficialFilesControllerImpl()
    
    var arrFile = [FileModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(tapToDone))
        navigationItem.title = "Files in OfficialData"
    }
    
    func loadData() {
        HUD.show(.systemActivity)
        controller.getListFile { [weak self] (success, files, error) in
            self?.arrFile = files
            self?.tableView.reloadData()
            HUD.hide(afterDelay: 0.3)
        }
    }
    
    @objc func tapToDone() {
        self.dismiss(animated: true)
    }


}

extension OfficialFilesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfficialFileTableCell", for: indexPath)
        let fileModel = arrFile[indexPath.row]
        if let fileCell = cell as? FileTableCell {
            fileCell.setData(file: fileModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fileInfo = arrFile[indexPath.row]
        let viewer = XMLContentViewController()
        viewer.filePath = fileInfo.path
        viewer.fileName = fileInfo.name
        let nav = UINavigationController(rootViewController: viewer)
        self.present(nav, animated: true)
    }
}
