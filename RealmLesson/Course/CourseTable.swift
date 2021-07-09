//
//  Course.swift
//  RealmLesson
//
//  Created by Roma Latynia on 4/14/21.
//

import RealmSwift
import UIKit

private enum Constants {
    static let identifier = "cell"
    static let title = "Courses"
}

class CourseTable: UITableViewController {
    
    private var courses = [Course]()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableView()
        createNavigationController()
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.identifier)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTableView),
            name: .tableReloadDataCourse,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.backgroundColor = .systemGreen
    }

    private func createNavigationController() {
        navigationItem.title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addAction)
        )
    }
    
    private func setupCell(cell: UITableViewCell, withSource source: Course) {
        cell.textLabel?.text = "\(source.nameCourse ?? "")"
    }
    
    @objc func addAction() {
        navigationController?.pushViewController(AddCourseTable(), animated: true)
    }
    
    @objc private func updateTableView() {
        courses = [Course]()
        DBManager.shared.getAllCourses { [weak self] (course) in
            guard let self = self else { return }
            self.courses.append(contentsOf: course)
            guard self.tableView != nil else { return }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier, for: indexPath)
        setupCell(cell: cell, withSource: courses[indexPath.row])
        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }
        let editingRows = courses[indexPath.row]
        DBManager.shared.deleteCourse(course: editingRows)
        NotificationCenter.default.post(name: .tableReloadDataCourse, object: nil)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let object = courses[indexPath.row]
        let vc = AddCourseTable(course: object)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
