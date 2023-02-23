//
//  OfficialFilesController.swift
//  rta-assigment5
//
//  Created by Truong Luan on 2/23/23.
//

import Foundation

protocol OfficialFilesController: GetListFile {
    
}

class OfficialFilesControllerImpl: OfficialFilesController {
    
    func getListFile(completion: @escaping(CompletionResults<[FileModel]>) -> Void) {
        let path = Constants.pathOfficialData
        DispatchQueue.global().async {
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: path)
                let result: [FileModel] = files.map { name -> FileModel in
                    return FileModel(path: "\(path)/\(name)", name: name)
                }
                DispatchQueue.main.async {
                    completion((false, result, nil))
                }
            } catch {
                DispatchQueue.main.async {
                    completion((false, [FileModel](), error.localizedDescription))
                }
            }
        }
    }
}
