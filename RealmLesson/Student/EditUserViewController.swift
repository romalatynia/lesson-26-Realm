//
//  AddContactViewController.swift
//  RealmLesson
//
//  Created by Roma Latynia on 4/7/21.
//

import RealmSwift
import UIKit

private enum Constants {
    static let identifier = "cell"
    static let titleStudent = "New student"
    static let titleTeacher = "New teacher"
    static let studentInfo = "Student info"
    static let course = "Course"
    static let name = "name"
    static let lastName = "last Name"
    static let email = "e-Mail"
    static let noName = "No name"
    static let noLastName = "No last Name"
    static let noEmail = "No e-Mail"
    static let save = "Save"
    static let cancel = "Cancel"
    static let width: CGFloat = 20
    static let height: CGFloat = 10
    static let section = 2
    static let rowInSection = 3
    static let student = "Студент"
    static let teacher = "Преподаватель"
    static let taught = "courses taught"
    static let studied = "courses studied"
}

class EditUserViewController: UIViewController {
    
    private var tableView: UITableView!
    private var user: User?
    private let nameTextField = TextField.createField(withName: nil, and: Constants.name, tag: 0, delegade: nil)
    private let lastNameTextField = TextField.createField(withName: nil, and: Constants.lastName, tag: 1, delegade: nil)
    private let emailTextField = TextField.createField(withName: nil, and: Constants.email, tag: 2, delegade: nil)
    private lazy var roleController: UISegmentedControl = {
        let controller = UISegmentedControl(items: [Constants.student, Constants.teacher])
        controller.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
        controller.selectedSegmentIndex = 0
        controller.addTarget(self, action: #selector(roleValueChanged(sender:)), for: .valueChanged)
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationController()
        createTableView()
        setupCells()
    }
    
    init (user: User? = nil) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func createNavigationController() {
        navigationItem.title = Constants.titleStudent
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .systemGray
        let barControl = UIBarButtonItem(customView: roleController)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                title: Constants.save,
                style: .plain,
                target: self,
                action: #selector(saveButtonPressed(sender:))
            ),
            barControl
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Constants.cancel,
            style: .plain,
            target: self,
            action: #selector(cancelButtonPressed(sender:)))
    }
    
    private func createTableView() {
        tableView = UITableView( frame: view.bounds, style: .insetGrouped)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: Constants.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func currentTextField(index: Int) -> UITextField {
         var textField = UITextField()
         switch index {
         case 0:
            textField = nameTextField
         case 1:
            textField = lastNameTextField
         case 2:
            textField = emailTextField
         default:
             break
         }
         return textField
     }
    
    private func setupCells() {
        if let currrentStudent = user {
            nameTextField.text = currrentStudent.name
            lastNameTextField.text = currrentStudent.lastName
            emailTextField.text = currrentStudent.eMail
            roleController.selectedSegmentIndex = currrentStudent.role ?? 0
        }
    }
    
    private func workWithStudentData(user: User, name: String, lastName: String, eMail: String, segment: Int) {
        user.name = name
        user.lastName = lastName
        user.eMail = eMail
        user.role = segment
    }
    
    @objc func roleValueChanged(sender: UISegmentedControl) {
        if roleController.selectedSegmentIndex == 0 {
            navigationItem.title = Constants.titleStudent
            tableView.reloadData()
        } else {
            navigationItem.title = Constants.titleTeacher
            tableView.reloadData()
        }
    }
    
    @objc func saveButtonPressed(sender: UIBarButtonItem) {
        if let editUser = user {
            workWithStudentData(
                user: editUser,
                name: nameTextField.text ?? Constants.noName,
                lastName: lastNameTextField.text ?? Constants.noLastName,
                eMail: emailTextField.text ?? Constants.noEmail,
                segment: roleController.selectedSegmentIndex
            )
            DBManager.shared.editUser(user: user ?? User(), editUser: editUser)
        } else {
            guard let nameText = nameTextField.text,
                  let lastNameText = lastNameTextField.text,
                  let emailText = emailTextField.text else { return }
            let newUser = User()
            workWithStudentData(
                user: newUser,
                name: !nameText.isEmpty ? nameText : Constants.noName,
                lastName: !lastNameText.isEmpty ? lastNameText : Constants.noLastName,
                eMail: !emailText.isEmpty ? emailText : Constants.noEmail,
                segment: roleController.selectedSegmentIndex
            )
            DBManager.shared.saveUser(user: newUser)
        }
        NotificationCenter.default.post(name: .tableReloadDataUser, object: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelButtonPressed(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

extension EditUserViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if roleController.selectedSegmentIndex == 0 {
            return Constants.section
        } else {
            return Constants.rowInSection
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if roleController.selectedSegmentIndex == 0 {
            switch section {
            case 0:
                return Constants.rowInSection
            case 1:
                return user?.courseСonnection?.count ?? 0
            default:
                return 0
            }
        } else {
            switch section {
            case 0:
                return Constants.rowInSection
            case 1:
                if user?.course != nil {
                    return 1
                }
                return 0
            case 2:
                return user?.course?.owner?.count ?? 0
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.identifier,
            for: indexPath
       ) as? TableViewCell else { return UITableViewCell() }
        
        if indexPath.section == .zero {
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
        } else if roleController.selectedSegmentIndex == 0 {
            guard let course = user?.courseСonnection?[indexPath.row] else { return cell }
            cell.textLabel?.text = course.nameCourse
        } else if indexPath.section == 1 {
            guard let course = user?.course else { return cell }
            cell.textLabel?.text = course.nameCourse
        } else {
            guard let students = user?.course?.owner?[indexPath.row] else { return cell }
            cell.textLabel?.text = "\(students.name ?? "") \(students.lastName ?? "")"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if roleController.selectedSegmentIndex == 0 {
            return section == .zero ? Constants.studentInfo : Constants.course
        } else {
            switch section {
            case 0:
                return Constants.studentInfo
            case 1:
                return Constants.taught
            case 2:
                return Constants.studied
            default:
                return String()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
