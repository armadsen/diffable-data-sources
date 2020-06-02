//
//  ToDoTableViewCell.swift
//  ToDo
//
//  Created by Andrew R Madsen on 6/2/20.
//  Copyright © 2020 Open Reel Software. All rights reserved.
//

import UIKit

protocol ToDoTableViewCellDelegate : class {
    func statusSwitchWasTappedIn(cell: ToDoTableViewCell)
}

class ToDoTableViewCell: UITableViewCell {

    static let identifier = "ToDoCell"

    @IBAction func statusChanged(sender: UISwitch) {
        delegate?.statusSwitchWasTappedIn(cell: self)
    }

    // MARK: - Properties

    weak var delegate: ToDoTableViewCellDelegate?

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!
}
