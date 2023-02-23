//
//  ReviewDataController.swift
//  rta-assigment5
//
//  Created by Truong Luan on 2/22/23.
//

import Foundation


class ReviewDataControllerImpl {
    
    private var group = DispatchGroup()
    private var queue = OperationQueue()
    
    init() {
        queue.maxConcurrentOperationCount = 1
    }
    
    func prepareImportation() {
        if FileManager.default.fileExists(atPath: Constants.pathOfficialData) {
            return
        }
        do {
            try FileManager.default.createDirectory(atPath: Constants.pathOfficialData, withIntermediateDirectories: false)
        } catch {
            // TODO:
        }
    }
    
    func startImportation(instanceIds: [InstanceIDModel],
                          onProgress: @escaping(String) -> Void,
                          completion: @escaping() -> Void) {
        // Step 1: Copy file
        let count = instanceIds.count
        for (index, obj) in instanceIds.enumerated() {
            group.enter()
            let blockAction = BlockOperation { [weak self] in
                self?.copyFile(toPath: Constants.pathOfficialData, file: obj.fileInfo)
            }
            blockAction.completionBlock = { [weak self] in
                self?.group.leave()
                DispatchQueue.main.async {
                    let currentProgress = ((index + 1) * 100) / count
                    onProgress("\(currentProgress)%/100%")
                }
            }
            queue.addOperation(blockAction)
        }
        
        // Step 2: insert records to sqlite
        for i in instanceIds {
            group.enter()
            let blockAction = BlockOperation {
                DBHelper.insertInstanceIDInfo(instanceID: i)
            }
            blockAction.completionBlock = { [weak self] in
                self?.group.leave()
            }
            queue.addOperation(blockAction)
        }
        
        group.notify(queue: .main) {
            completion()
        }
        
    }
    
    func copyFile(toPath: String, file: FileModel) {
        guard FileManager.default.fileExists(atPath: file.path) else {
            return
        }
        let newPath = toPath + "/" + file.name
        do {
            try FileManager.default.copyItem(atPath: file.path, toPath: newPath)
        } catch {
            print("copy file error", error)
        }
    }

}
