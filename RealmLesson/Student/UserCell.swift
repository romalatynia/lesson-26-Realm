//
//  UserCell.swift
//  RealmLesson
//
//  Created by Roma Latynia on 5/3/21.
//

import UIKit

private enum Constants {
    static let student = "Студент"
    static let teacher = "Преподаватель"
}

class UserCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        detailTextLabel?.text = nil
    }
    
     func setupCell(user: User) {
        textLabel?.text = "\(user.name ?? "") \(user.lastName ?? "")"
        if user.role == 0 {
            detailTextLabel?.text = Constants.student
        } else {
            detailTextLabel?.text = Constants.teacher
        }
    }
}
