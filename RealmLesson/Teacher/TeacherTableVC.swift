//
//  TeacherTableVC.swift
//  RealmLesson
//
//  Created by Roma Latynia on 5/12/21.
//

import RealmSwift
import UIKit

private enum Constants {
    static let identifier = "cell"
    static let title = "Teacher"
}

class TeacherTableVC: UITableViewController {
    
    private var teachers = [User]()
    private var lessonTitleName = [String: [User]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableView()
        createNavigationController()
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.register(TeacherTableVCell.self, forCellReuseIdentifier: Constants.identifier)
        loadData()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTableView),
            name: .tableReloadDataTeacherInCourse,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
        navigationController?.navigationBar.backgroundColor = .systemRed
    }
    
    private func createNavigationController() {
        navigationItem.title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func loadData() {
        lessonTitleName = [String: [User]]()
        teachers.forEach {
            if let subject = $0.course?.subject, !lessonTitleName.keys.contains(subject) {
                lessonTitleName.updateValue([$0], forKey: subject)
            } else if let subject = $0.course?.subject {
                var value = lessonTitleName[subject]
                value?.append($0)
                lessonTitleName[subject] = value
            }
        }
    }
    
    @objc private func updateTableView() {
        teachers = [User]()
        DBManager.shared.getAllStudents(role: 1) { [weak self] (teacher) in
            guard let self = self else { return }
            self.teachers.append(contentsOf: teacher)
            guard self.tableView != nil else { return }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
         lessonTitleName.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Array(lessonTitleName.values)[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.identifier,
                for: indexPath
        ) as? TeacherTableVCell else { fatalError() }
        let value = Array(lessonTitleName.values)[indexPath.section]
        let teacher = value[indexPath.row]
        cell.setupCell(user: teacher)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        [String](lessonTitleName.keys)[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let object = lessonTitleName.flatMap { $0.1 }
        let vc = EditUserViewController(user: object[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
