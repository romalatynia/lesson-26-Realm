//
//  ViewController.swift
//  RealmLesson
//
//  Created by Roma Latynia on 4/6/21.
//

import RealmSwift
import UIKit

private enum Constants {
    static let identifier = "cell"
    static let title = "Students"
}

class UserViewController: UIViewController {
    
    private var tableView: UITableView!
    private var students = [User]()
    
    private var eventsObserveToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableView()
        createNavigationController()
        createTableView()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTableView),
            name: .tableReloadDataUser,
            object: nil
        )
    }

    private func createNavigationController() {
        navigationItem.title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .systemGray
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addAction)
        )
    }
    
    private func createTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.register(UserCell.self, forCellReuseIdentifier: Constants.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    @objc func addAction() {
        navigationController?.pushViewController(EditUserViewController(), animated: true)
    }
    
    @objc private func updateTableView() {
        students = [User]()
        DBManager.shared.getAllUsers { [weak self] (student) in
            guard let self = self else { return }
            self.students.append(contentsOf: student)
            guard self.tableView != nil else { return }
            self.tableView.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension UserViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.identifier,
            for: indexPath
        ) as? UserCell else { return UITableViewCell() }
        cell.setupCell(user: students[indexPath.row])
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }
        let editingRows = students[indexPath.row]
        DBManager.shared.deleteUser(user: editingRows)
        NotificationCenter.default.post(name: .tableReloadDataUser, object: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let object = students[indexPath.row] 
        let vc = EditUserViewController(user: object)
        navigationController?.pushViewController(vc, animated: true)
    }
}
