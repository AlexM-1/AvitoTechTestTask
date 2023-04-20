//
//  Model.swift
//  AvitoTechTestTask
//
//  Created by Alex M on 19.04.2023.
//

import Foundation

struct AddServicesResponseCodable: Codable {
    let status: String
    var result: Result
}


struct Result: Codable {
    let title: String
    let actionTitle: String
    let selectedActionTitle: String
    var list: [List]
}


struct List: Codable {
    let id, title: String
    let description: String?
    let icon: Icon
    let price: String
    var isSelected: Bool
}


struct Icon: Codable {
    let the52X52: String

    enum CodingKeys: String, CodingKey {
        case the52X52 = "52x52"
    }
}

