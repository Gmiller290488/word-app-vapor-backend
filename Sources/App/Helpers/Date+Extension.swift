//
//  Date+Extension.swift
//  App
//
//  Created by Gareth Miller on 01/11/2019.
//

import Foundation

extension Date {

    static func todaysDateAsString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateString = formatter.string(from: self.init())
        let todaysDate = formatter.date(from: dateString)
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: todaysDate!)
    }
}
