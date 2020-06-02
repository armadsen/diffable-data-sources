//
//  Persistence.swift
//  ToDo
//
//  Created by Andrew R Madsen on 6/2/20.
//  Copyright © 2020 Open Reel Software. All rights reserved.
//

import Foundation

extension ToDoListViewController {
    func save() {
        do {
            let data = try JSONEncoder().encode(todosBySection)
            try data.write(to: url)
        } catch {
            NSLog("Error saving: \(error)")
        }
    }

    func load() -> [Section : [ToDo]] {
        do {
            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode([Section : [ToDo]].self, from: data)
            return result
        } catch {
            NSLog("Error saving: \(error)")
            return [:]
        }
    }

    var url: URL {
        let fm = FileManager.default
        let docsURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docsURL.appendingPathComponent("todos").appendingPathExtension("json")
    }
}
