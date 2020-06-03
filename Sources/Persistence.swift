//
//  Persistence.swift
//  ToDo
//
//  Created by Andrew R Madsen on 6/2/20.
//  Copyright © 2020 Open Reel Software. All rights reserved.
//

import UIKit

extension ToDoListViewController {

    func registerForBackgroundingNotification() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(willResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @objc func willResignActive(_ notification: Notification) {
        save()
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(todosBySection)
            try data.write(to: url)
        } catch {
            NSLog("Error saving: \(error)")
        }
    }

    func load() {
        do {
            let data = try Data(contentsOf: url)
            todosBySection = try JSONDecoder().decode([ToDo.Status : [ToDo]].self, from: data)
        } catch {
            NSLog("Error saving: \(error)")
        }
    }

    var url: URL {
        let fm = FileManager.default
        let docsURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docsURL.appendingPathComponent("todos").appendingPathExtension("json")
    }
}
