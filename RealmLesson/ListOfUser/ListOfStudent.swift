//
//  ListOfStudentsForCourse.swift
//  RealmLesson
//
//  Created by Roma Latynia on 4/16/21.
//

import RealmSwift
import UIKit

private enum Constants {
    static let done = "Done"
    static let indetifier = "cell"
    static let title = "Список студентов"
}

class ListOfStudent: UITableViewController {
    
    private var students = [User]()
    private var course: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableView()
        createNavigationControllerAndTableView()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTableView),
            name: .tableReloadDataStudent,
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
        guard let students = managedStudents.courseСonnection else { return false }
        return students.contains { course in course == self.course }
    }
  
    @objc func saveButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc private func updateTableView() {
        students = [User]()
        DBManager.shared.getAllStudents(role: 0) { [weak self] (student) in
            guard let self = self else { return }
            self.students.append(contentsOf: student)
            guard self.tableView != nil else { return }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.indetifier,
                for: indexPath
        ) as? ListOfManagerCell else { fatalError() }
        let student = students[indexPath.row]
        cell.setupView(object: student, isSelected: constainsObject(student))

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let cell = tableView.cellForRow(at: indexPath) as? ListOfManagerCell else { fatalError() }
        
        if cell.isPressed,
           let firstIndex = students[indexPath.row].courseСonnection?.firstIndex(
            where: { course in course == self.course ?? Course() }
           ) {
            DBManager.shared.deleteCourseStudent(student: students[indexPath.row], index: firstIndex)
        } else {
            DBManager.shared.addCourseStudent(student: students[indexPath.row], course: course ?? Course())
        }
        NotificationCenter.default.post(name: .tableReloadDataStudent, object: nil)
        NotificationCenter.default.post(name: .tableReloadDataUserInCourse, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
