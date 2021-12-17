//
//  Validator.swift
//  WeatherAppNAB
//
//  Created by Hung P Dang on 17/12/2021.
//

import Foundation
class ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}

protocol ValidatorConvertible {
    func validated(_ value: String) throws -> String
}

enum ValidatorType {
    case location
}

enum ValidatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .location: return LocationValidator()
        }
    }
}

struct LocationValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        if (value.count < 3)
        {
            throw ValidationError("Location must be more than 3 characters")
        }
        return value
    }
    
}
