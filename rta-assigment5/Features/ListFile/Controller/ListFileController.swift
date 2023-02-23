//
//  ListFileController.swift
//  rta-assigment5
//
//  Created by Truong Luan on 2/22/23.
//

import Foundation

protocol GetListFile {
    func getListFile(completion: @escaping(CompletionResults<[FileModel]>) -> Void)
}

protocol ListFileController: GetListFile {
    func initDataFolder(completion: @escaping(Completion) -> Void)
    func extractXmlFiles(parserManager: ParseActionManager,
                         completion: @escaping (CompletionResults<[InstanceIDModel]>) -> Void)
}

class ListFileControllerImpl: ListFileController {
    
    init() {
        
    }
    
    func initDataFolder(completion: @escaping(Completion) -> Void) {
        let path = Constants.pathData
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false)
            } catch {
                completion((false, error.localizedDescription))
                return
            }
        }
        if let files = try? FileManager.default.contentsOfDirectory(atPath: path),
           !files.isEmpty {
            completion((true, nil))
            return
        }
        
        let files = Bundle.main.paths(forResourcesOfType: "xml", inDirectory: "Data")
        DispatchQueue.global().async {
            for (index, obj) in files.enumerated() {
                guard let name = obj.components(separatedBy: "/").last else {
                    continue
                }
                let newPath = "\(path)/\(name)"
                if !FileManager.default.fileExists(atPath: newPath) {
                    do {
                        try FileManager.default.copyItem(atPath: obj, toPath: newPath)
                        print("copy \(index+1)/\(files.count)")
                    } catch {
                        DispatchQueue.main.async {
                            completion((false, error.localizedDescription))
                        }
                        return
                    }
                }
            }
            DispatchQueue.main.async {
                completion((true, nil))
            }
        }
    }
    
    func getListFile(completion: @escaping(CompletionResults<[FileModel]>) -> Void) {
        let path = Constants.pathData
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
    
    func extractXmlFiles(parserManager: ParseActionManager, completion: @escaping (CompletionResults<[InstanceIDModel]>) -> Void) {
        parserManager.start(completion: completion)
    }
}
