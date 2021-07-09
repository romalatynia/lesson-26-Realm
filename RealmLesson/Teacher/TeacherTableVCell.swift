//
//  TeacherTableVCell.swift
//  RealmLesson
//
//  Created by Roma Latynia on 5/13/21.
//

import UIKit

class TeacherTableVCell: UITableViewCell {
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
        detailTextLabel?.text = "Курсы \([user.course].count)"
    }
}
