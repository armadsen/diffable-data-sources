//
//  ToDoListViewController.swift
//  ToDo
//
//  Created by Andrew R Madsen on 6/2/20.
//  Copyright © 2020 Open Reel Software. All rights reserved.
//

import UIKit

class ToDoListViewController: UIViewController, UITableViewDelegate, ToDoTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        registerForBackgroundingNotification()
        navigationItem.leftBarButtonItem = editButtonItem

        dataSource = ToDoDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, todo) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier, for: indexPath) as! ToDoTableViewCell

            cell.label.text = todo.text
            cell.statusSwitch.isOn = todo.status == .complete
            cell.delegate = self

            return cell
        })
        load()
    }

    @IBAction func addToDo(_ sender: Any) {
        let alertController = UIAlertController(title: "Create New ToDo", message: "Enter your todo item", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Buy Milk"
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak self] _ in
            guard let self = self, let text = alertController.textFields?.first?.text else { return }
            let todo = ToDo(text: text)
            var snapshot = self.dataSource.snapshot()
            snapshot.appendItems([todo], toSection: .incomplete)
            self.dataSource.apply(snapshot)
        }))

        present(alertController, animated: true, completion: nil)
    }

    // MARK: - ToDoTableViewCellDelegate

    func statusSwitchWasTappedIn(cell: ToDoTableViewCell) {

        guard let indexPath = tableView.indexPath(for: cell),
            var todo = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        let newStatus: ToDo.Status = todo.status == .complete ? .incomplete : .complete
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([todo])
        todo.status = newStatus
        snapshot.appendItems([todo], toSection: newStatus)
        dataSource.apply(snapshot)
    }

    // MARK: - Overrides

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        switch editingStyle {
        case .delete:
            guard let todo = dataSource.itemIdentifier(for: indexPath) else { return }
            var snapshot = dataSource.snapshot()
            snapshot.deleteItems([todo])
            dataSource.apply(snapshot)
        default:
            break
        }
    }

    // MARK: - Properties

    var todosBySection = [ToDo.Status : [ToDo]]()

    @IBOutlet weak var tableView: UITableView!
    var dataSource: ToDoDiffableDataSource!
}
