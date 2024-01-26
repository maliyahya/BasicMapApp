//
//  String+Extensions.swift
//  MapApp
//
//  Created by Muhammet Ali Yahyaoğlu on 26.01.2024.
//

import Foundation

extension String{
    
    var formatPhoneForCall:String{
        self.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
}
