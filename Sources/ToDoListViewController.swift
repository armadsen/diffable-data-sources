//
//  ToDoListViewController.swift
//  ToDo
//
//  Created by Andrew R Madsen on 6/2/20.
//  Copyright © 2020 Open Reel Software. All rights reserved.
//

import UIKit

enum Section: Int, CaseIterable, Codable {
    case incomplete, complete
}

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ToDoTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        todosBySection = load()
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

            let section = Section.incomplete
            let row = self.todosBySection[section]?.count ?? 0
            self.todosBySection[section, default: []].append(todo)
            self.tableView.insertRows(at: [IndexPath(row: row, section: section.rawValue)], with: .automatic)
        }))

        present(alertController, animated: true, completion: nil)
    }

    // MARK: - ToDoTableViewCellDelegate

    func statusSwitchWasTappedIn(cell: ToDoTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let section = Section(rawValue: indexPath.section) else { return }
        guard let todo = todosBySection[section]?[indexPath.row] else { return }

        let newSection: Section = section == .complete ? .incomplete : .complete
        let newIndexPath = IndexPath(row: todosBySection[newSection]?.count ?? 0, section: newSection.rawValue)
        todosBySection[section]?.remove(at: indexPath.row)
        todosBySection[newSection]?.append(todo)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }

    // MARK: - Overrides

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    // MARK: - Table View Data Source

    func numberOfSections(in tableView: UITableView) -> Int { Section.allCases.count }

    func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        let section = Section(rawValue: sectionIndex) ?? .incomplete
        return todosBySection[section]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier, for: indexPath) as! ToDoTableViewCell

        let section = Section(rawValue: indexPath.section)!
        cell.label.text = todosBySection[section]![indexPath.row].text
        cell.statusSwitch.isOn = section == .complete
        cell.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection sectionIndex: Int) -> String? {
        let section = Section(rawValue: sectionIndex)!
        switch section {
        case .complete:
            return "Complete"
        case .incomplete:
            return "Incomplete"
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let section = Section(rawValue: indexPath.section)!
            todosBySection[section]?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }

    // MARK: - Properties

    private(set) var todosBySection = [Section : [ToDo]]() {
        didSet {
            save()
        }
    }

    @IBOutlet weak var tableView: UITableView!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
