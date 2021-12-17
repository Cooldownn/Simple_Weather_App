//
//  Globals.swift
//  WeatherAppNAB
//
//  Created by Hung P Dang on 17/12/2021.
//

import Foundation
class Global {
    static func UnixTimeStampToString(timeStamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM YYYY"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}
