//
//  ListFileViewController.swift
//  rta-assigment5
//
//  Created by Truong Luan on 2/22/23.
//

import UIKit
import PKHUD

class ListFileViewController: UIViewController {
    
    var controller: ListFileController = ListFileControllerImpl()
    
    var arrFile = [FileModel]()
    
    @IBOutlet weak var tableView: UITableView!
    
    var rightActionButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        initData()
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = true
        
        rightActionButton = UIBarButtonItem.init(title: "Select", style: .plain, target: self, action: #selector(tapToImport))
        navigationItem.rightBarButtonItem = rightActionButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "OfficialData", style: .plain, target: self, action: #selector(tapToOfficialData))
        navigationItem.title = "Files in Data"
    }
    
    @objc func tapToImport() {
        if tableView.isEditing {
            // import
            rightActionButton?.title = "Select"
            prepareDataForReview(indexRow: tableView.indexPathsForSelectedRows)
            tableView.setEditing(false, animated: true)
        } else {
            // selection
            rightActionButton?.title = "Import"
            tableView.setEditing(true, animated: true)
        }
    }
    
    @objc func tapToOfficialData() {
        let story = UIStoryboard(name: "Main", bundle: .main)
        let viewController = story.instantiateViewController(withIdentifier: "OfficialFilesViewController")
        let nav = UINavigationController(rootViewController: viewController)
        nav.modalTransitionStyle = .crossDissolve
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true)
        
    }
    
    func initData() {
        HUD.show(.labeledProgress(title: "Init Data", subtitle: "Waiting..."), onView: self.view)
        controller.initDataFolder { [weak self] (success, error) in
            guard let self = self else {
                return
            }
            HUD.hide()
            if success {
                HUD.flash(.labeledSuccess(title: "Success", subtitle: "Init Data Successfully!"), onView: self.view, delay: 1)
            } else {
                self.showAlert(title: "Error", message: error ?? "Something went wrong!")
            }
            // next step
            self.getFileData()
        }
    }
    
    func getFileData() {
        controller.getListFile { [weak self] (success, files, error) in
            self?.arrFile = files
            self?.tableView.reloadData()
        }
    }
    
    func prepareDataForReview(indexRow: [IndexPath]?) {
        guard let indexs = indexRow else {
            return
        }
        let filePaths = indexs.map { arrFile[$0.row] }.map { $0.path }
        let parserManager = ParseActionManagerImpl(filePaths: filePaths)
        HUD.show(.progress)
        controller.extractXmlFiles(parserManager: parserManager) { [weak self] (success, result, error) in
            HUD.hide()
            let story = UIStoryboard(name: "Main", bundle: .main)
            let viewController = story.instantiateViewController(withIdentifier: "ReviewDataViewController")
            if let reviewDataScreen = viewController as? ReviewDataViewController {
                reviewDataScreen.arrInstanceId = result
            }
            let nav = UINavigationController(rootViewController: viewController)
            self?.present(nav, animated: true)
        }
    }

}

extension ListFileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileTableCell", for: indexPath)
        let fileModel = arrFile[indexPath.row]
        if let fileCell = cell as? FileTableCell {
            fileCell.setData(file: fileModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
