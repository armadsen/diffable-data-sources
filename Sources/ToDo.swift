//
//  ToDo.swift
//  ToDo
//
//  Created by Andrew R Madsen on 6/2/20.
//  Copyright © 2020 Open Reel Software. All rights reserved.
//

import Foundation


struct ToDo: Hashable, Codable {

    enum Status: Int, CaseIterable, Codable {
        case incomplete, complete
    }
    
    var text: String
    var status: Status
    let uuid = UUID()

    init(text: String, status: Status = .incomplete) {
        self.text = text
        self.status = status
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    static func == (lhs: ToDo, rhs: ToDo) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
