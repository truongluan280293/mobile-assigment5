//
//  DBHelper.swift
//  rta-assigment5
//
//  Created by Truong Luan on 2/23/23.
//

import Foundation
import SQLite3
import SQLite

struct FileInfoTable {
    let fileInfoTable = Table("FileInfo")
    let primaryCol = Expression<Int64>("id")
    let instanceIDCol = Expression<String>("instance_id")
    let filePathCol = Expression<String>("file_path")
}

class DBHelper {
    
    static func createFileInfoTable() {
        let table = FileInfoTable()
        do {
            let db = try Connection(Constants.pathDB)
            try db.run( table.fileInfoTable.create(ifNotExists: true, block: { builder in
                builder.column(table.primaryCol, primaryKey: .autoincrement)
                builder.column(table.instanceIDCol)
                builder.column(table.filePathCol)
            }))
            print("\(NSHomeDirectory())/Documents")
        } catch {
            print("create db error:", error)
        }
    }
    
    static func insertInstanceIDInfo(instanceID: InstanceIDModel) {
        let table = FileInfoTable()
        do {
            let officialPath = "\(Constants.pathOfficialData)/\(instanceID.fileInfo.name)"
            let db = try Connection(Constants.pathDB)
            try db.run(table.fileInfoTable.insert(table.filePathCol <- officialPath,
                                              table.instanceIDCol <- instanceID.id))
            print("inserted: \(instanceID.id)")
        } catch {
            print("insert row error:", error)
        }
    }
}
