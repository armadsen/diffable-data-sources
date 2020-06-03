//
//  Persistence.swift
//  ToDo
//
//  Created by Andrew R Madsen on 6/2/20.
//  Copyright © 2020 Open Reel Software. All rights reserved.
//

import Foundation
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
            let todos = dataSource.snapshot().itemIdentifiers
            let data = try JSONEncoder().encode(todos)
            try data.write(to: url)
        } catch {
            NSLog("Error saving: \(error)")
        }
    }

    func load() {
        do {
            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode([ToDo].self, from: data)

            var snapshot = NSDiffableDataSourceSnapshot<ToDo.Status, ToDo>()
            snapshot.appendSections(ToDo.Status.allCases)
            for status in ToDo.Status.allCases {
                let todos = result.filter { $0.status == status }
                snapshot.appendItems(todos, toSection: status)
            }
            dataSource.apply(snapshot)
        } catch {
            NSLog("Error loading: \(error)")
        }
    }

    var url: URL {
        let fm = FileManager.default
        let docsURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docsURL.appendingPathComponent("todos2").appendingPathExtension("json")
    }
}
