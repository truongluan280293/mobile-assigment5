//
//  Constants.swift
//  rta-assigment5
//
//  Created by Truong Luan on 2/22/23.
//

import Foundation

typealias Completion = (Bool, String?) // bool is success, String? is error if have
typealias CompletionResults<T> = (Bool, T, String?) // T is any object


class Constants {
    static let pathData = "\(NSHomeDirectory())/Documents/Data"
    static let pathOfficialData = "\(NSHomeDirectory())/Documents/OfficialData"
    static let pathDB = "\(NSHomeDirectory())/Documents/rta.sqlite3"
}
