//
//  AddCourseTable.swift
//  RealmLesson
//
//  Created by Roma Latynia on 4/14/21.
//

import RealmSwift
import UIKit

private enum Constants {
    static let edit = UIImage(named: "add student to course")
    static let identifier = "cell"
    static let save = "Save"
    static let cancel = "Cancel"
    static let width: CGFloat = 20
    static let height: CGFloat = 10
    static let section = 2
    static let rowInSection = 4
    static let title = "New course"
    static let editStudentsList = "Edit students list"
    static let courseInfoSectionName = "Course info"
    static let studentSectionName = "Student"
    static let noName = "no name"
    static let noSubject = "no subject"
    static let noBranch = "no branch"
    static let nameCourse = "Name Course"
    static let subject = "Subject"
    static let branch = "Branch"
    static let chooseTeacher = "Выберите преподавателя"
}

class AddCourseTable: UITableViewController {
    
    private var course: Course?
    private var students = [User]()
    private let nameCourseTextField = TextField.createField(
        withName: nil,
        and: Constants.nameCourse,
        tag: 0,
        delegade: nil
    )
    private let subjectTextField = TextField.createField(
        withName: nil,
        and: Constants.subject,
        tag: 1,
        delegade: nil
    )
    private let branchTextField = TextField.createField(
        withName: nil,
        and: Constants.branch,
        tag: 2,
        delegade: nil
    )

    init (course: Course? = nil) {
        self.course = course
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableView()
        createNavigationController()
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: Constants.identifier)
        setupCells()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTableView),
            name: .tableReloadDataUserInCourse,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.backgroundColor = .systemGreen
        tableView.reloadData()
    }
    
    private func createNavigationController() {
        navigationItem.title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Constants.save,
            style: .plain,
            target: self,
            action: #selector(saveButtonPressed(sender:))
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Constants.cancel,
            style: .plain,
            target: self,
            action: #selector(cancelButtonPressed(sender:))
        )
    }
    
    private func currentTextField(index: Int) -> UITextField {
        var textField = UITextField()
        switch index {
        case 0:
            textField = nameCourseTextField
        case 1:
            textField = subjectTextField
        case 2:
            textField = branchTextField
        default:
            break
        }
        return textField
    }
    
    private func setupCells() {
        if let currrentCourse = course {
            nameCourseTextField.text = currrentCourse.nameCourse
            subjectTextField.text = currrentCourse.subject
            branchTextField.text = currrentCourse.branch
        }
    }
    
    private func workWithCourseData(course: Course, nameCourse: String, subject: String, branch: String) {
        course.nameCourse = nameCourse
        course.subject = subject
        course.branch = branch
    }
    
    @objc func saveButtonPressed(sender: UIBarButtonItem) {
        if let editCourse = course {
                workWithCourseData(
                    course: editCourse,
                    nameCourse: nameCourseTextField.text ?? Constants.noName,
                    subject: subjectTextField.text ?? Constants.noSubject,
                    branch: branchTextField.text ?? Constants.noBranch
                )
            DBManager.shared.editCourse(course: course ?? Course(), editCourse: editCourse)
        } else {
            guard let nameCourseText = nameCourseTextField.text,
                  let subjectText = subjectTextField.text,
                  let branchText = branchTextField.text else { return }
            let newCourse = Course()
            workWithCourseData(
                course: newCourse,
                nameCourse: !nameCourseText.isEmpty ? nameCourseText : Constants.noName,
                subject: !subjectText.isEmpty ? subjectText : Constants.noSubject,
                branch: !branchText.isEmpty ? branchText : Constants.noBranch
            )
            DBManager.shared.addCourse(course: newCourse)
        }
        NotificationCenter.default.post(name: .tableReloadDataCourse, object: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelButtonPressed (sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func updateTableView() {
        DBManager.shared.getAllCourses { [weak self] (course) in
            guard let self = self else { return }
            course.forEach {
                if $0 == self.course {
                    self.course = $0
                    guard self.tableView != nil else { return }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        Constants.section
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Constants.rowInSection
        case 1:
            return (course?.owner?.count ?? 0) + 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.identifier,
            for: indexPath
        ) as? TableViewCell else { return UITableViewCell() } 
        
        if indexPath.section == .zero {
            if indexPath.row == 3 {
                if course?.ownerTeacher == [User]() || course?.ownerTeacher == nil {
                    cell.textLabel?.textColor = .systemGray
                    cell.textLabel?.text = Constants.chooseTeacher
                } else if let teacher = course?.ownerTeacher?.first {
                    cell.textLabel?.textColor = .black
                    cell.textLabel?.text = "\(teacher.name ?? "") \(teacher.lastName ?? "")"
                }
                return cell
            }
            let textField = currentTextField(index: indexPath.row)
            cell.contentView.addSubview(textField)
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.topAnchor.constraint(
                equalTo: cell.contentView.topAnchor,
                constant: Constants.height
            ).isActive = true
            textField.bottomAnchor.constraint(
                equalTo: cell.contentView.bottomAnchor,
                constant: -Constants.height
            ).isActive = true
            textField.leadingAnchor.constraint(
                equalTo: cell.contentView.leadingAnchor,
                constant: Constants.width
            ).isActive = true
            textField.trailingAnchor.constraint(
                equalTo: cell.contentView.trailingAnchor,
                constant: -Constants.width
            ).isActive = true
        } else {
            if indexPath.row == 0 {
                cell.imageView?.image = Constants.edit
                cell.textLabel?.text = Constants.editStudentsList
            } else if indexPath.row < (course?.owner?.count ?? 0) + 1 {
                guard let student = course?.owner?[indexPath.row - 1] else { return cell }
                cell.textLabel?.text = "\(student.name ?? "") \(student.lastName ?? "")"
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == .zero ? Constants.courseInfoSectionName : Constants.studentSectionName
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0, indexPath.row == 3 {
            let listOfTeacherVC = ListOfTeacher(course: course)
            let nc = UINavigationController(rootViewController: listOfTeacherVC)
            nc.modalPresentationStyle = .popover
            present(nc, animated: true, completion: nil)
        }
        if indexPath.section == 1, indexPath.row == 0 {
            let listOfStudentsVC = ListOfStudent(course: course)
            let nc = UINavigationController(rootViewController: listOfStudentsVC)
            nc.modalPresentationStyle = .popover
            present(nc, animated: true, completion: nil)
        } else if indexPath.section == 1, indexPath.row > 0 {
            let object = students[indexPath.row - 1]
            let vc = EditUserViewController(user: object)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
