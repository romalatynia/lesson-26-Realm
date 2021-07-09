//
//  ListOfTeacher.swift
//  RealmLesson
//
//  Created by Roma Latynia on 5/3/21.
//

import RealmSwift
import UIKit

private enum Constants {
    static let done = "Done"
    static let indetifier = "cell"
    static let title = "Список преполавтелей"
}

class ListOfTeacher: UITableViewController {
    
    private var teachers = [User]()
    private var course: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableView()
        createNavigationControllerAndTableView()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTableView),
            name: .tableReloadDataTeacher,
            object: nil
        )
    }
    
    init (course: Course? = nil) {
        self.course = course
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func createNavigationControllerAndTableView() {
        navigationController?.navigationBar.backgroundColor = .systemBlue
        title = Constants.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Constants.done,
            style: .plain,
            target: self,
            action: #selector(saveButtonPressed)
        )
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.register(ListOfManagerCell.self, forCellReuseIdentifier: Constants.indetifier)
    }
    
    private func constainsObject(_ managedStudents: User) -> Bool {
        managedStudents.course == course
    }
    
    @objc func saveButtonPressed() {
        dismiss(animated: true)
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        teachers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.indetifier,
                for: indexPath
        ) as? ListOfManagerCell else { fatalError() }
        let student = teachers[indexPath.row]
        cell.setupView(object: student, isSelected: constainsObject(student))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let cell = tableView.cellForRow(at: indexPath) as? ListOfManagerCell else { fatalError() }
        
        if cell.isPressed {
            DBManager.shared.deleteCourseTeacher(teacher: teachers[indexPath.row])
            
        } else if let course = course {
            DBManager.shared.addCourseTeacher(teacher: teachers[indexPath.row], course: course)
        }
        NotificationCenter.default.post(name: .tableReloadDataTeacher, object: nil)
        NotificationCenter.default.post(name: .tableReloadDataTeacherInCourse, object: nil)
        NotificationCenter.default.post(name: .tableReloadDataUserInCourse, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
