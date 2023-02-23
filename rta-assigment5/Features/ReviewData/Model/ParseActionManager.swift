//
//  ParseActionManager.swift
//  rta-assigment5
//
//  Created by Truong Luan on 2/22/23.
//

import Foundation

protocol ParseActionManager {
    var filePaths: [String] {get}
    func start(completion: @escaping(CompletionResults<[InstanceIDModel]>) -> Void)
}

class ParseActionManagerImpl: ParseActionManager {
    private var queue: OperationQueue
    private(set) var filePaths: [String]
    
    private var arrParser = [InstanceIDParser]()
    private var dispatchGroup = DispatchGroup()
    
    init(filePaths: [String]) {
        self.filePaths = filePaths
        self.queue = OperationQueue()
        self.queue.maxConcurrentOperationCount = 1
    }
    
    deinit {
        print("deinit ParseActionManagerImpl")
    }
    
    func start(completion: @escaping(CompletionResults<[InstanceIDModel]>) -> Void) {
        var results = [InstanceIDModel]()
        for i in filePaths {
            dispatchGroup.enter()
            let parser = InstanceIDParser(path: i)
            arrParser.append(parser)
            queue.addOperation {
                let fileInfo = FileModel(path: i,
                                         name: i.components(separatedBy: "/").last ?? "")
                parser.getFirstValue(of: "instanceID") { [weak self] (success, id, error) in
                    print("one xml done:", id ?? "-")
                    if let id = id {
                        results.append(InstanceIDModel(id: id, fileInfo: fileInfo))
                    }
                    self?.dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion((true, results, nil))
        }
    }
}
