//
//  FileXMLParser.swift
//  rta-assigment5
//
//  Created by Truong Luan on 2/22/23.
//

import Foundation


protocol FileXMLParser {
    func getFirstValue(of element: String,
                      completion: @escaping(CompletionResults<String?>) -> Void)
}

class InstanceIDParser: NSObject, XMLParserDelegate, FileXMLParser {
    var path: String
    
    private(set) var instanceID: String?
    private(set) var element: String?
    private var finish: ((CompletionResults<String?>) -> Void)? // String? is instanceID value
    private var isTagFound = false
    
    init(path: String) {
        self.path = path
    }
    
    func getFirstValue(of element: String,
                       completion: @escaping (CompletionResults<String?>) -> Void) {
        finish = completion
        guard FileManager.default.fileExists(atPath: path) else {
            finish?((false, nil, "File is not exist"))
            return
        }
        let url = URL(filePath: path)
        self.element = element
        do {
            let dataXML = try Data.init(contentsOf: url)
            let parser = XMLParser(data: dataXML)
            parser.delegate = self
            parser.parse()
        } catch {
            finish?((false, nil, error.localizedDescription))
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        guard let tagName = self.element else {
            return
        }
        if elementName == tagName {
            isTagFound = true
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if isTagFound == true && instanceID == nil {
            instanceID = string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let tagName = self.element else {
            return
        }
        if elementName == tagName {
            isTagFound = false
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        finish?((false, nil, parseError.localizedDescription))
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        finish?((true, instanceID, nil))
    }
    
}

