//
//  ToDoDiffableDataSource.swift
//  ToDo
//
//  Created by Andrew R Madsen on 6/2/20.
//  Copyright © 2020 Open Reel Software. All rights reserved.
//

import UIKit

class ToDoDiffableDataSource: UITableViewDiffableDataSource<ToDo.Status, ToDo> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let status = snapshot().sectionIdentifiers[section]
        switch status {
        case .incomplete:
            return "Incomplete"
        case .complete:
            return "Complete"
        }
    }
}
