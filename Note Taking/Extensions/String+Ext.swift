//
//  String+Ext.swift
//  Note Taking
//
//  Created by trucht on 10/22/19.
//  Copyright © 2019 Truc. All rights reserved.
//

import Foundation

extension String{
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
    
    func HTMLImageCorrector() -> String {
        var HTMLToBeReturned = self
        while HTMLToBeReturned.range(of: "(?<=width=\")[^\" height]+", options: .regularExpression) != nil{
            if let match = HTMLToBeReturned.range(of: "(?<=width=\")[^\" height]+", options: .regularExpression) {
                HTMLToBeReturned.removeSubrange(match)
                if let match2 = HTMLToBeReturned.range(of: "(?<=height=\")[^\"]+", options: .regularExpression) {
                    HTMLToBeReturned.removeSubrange(match2)
                    let string2del = "width=\"\" height=\"\""
                    HTMLToBeReturned = HTMLToBeReturned.replacingOccurrences(of: string2del, with: "style=\"width: 100%\"")
                }
            }
            
        }
        
        return HTMLToBeReturned
    }
}
