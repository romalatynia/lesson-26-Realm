//
//  ListOfManagerCell.swift
//  RealmLesson
//
//  Created by Roma Latynia on 4/22/21.
//

import UIKit

private enum Constants {
    static let bookmarkPressed = "bookmark_pressed"
    static let bookmark = "bookmark"
    static let student = "Студент"
    static let teacher = "Преподаватель"
}

class ListOfManagerCell: UITableViewCell {
    var isPressed: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        accessoryView = nil
        imageView?.image = nil
        isPressed = false
    }
    
    func setupView(object: User, isSelected: Bool? = nil) {
        let image: UIImage? = UIImage()
        textLabel?.text = "\(object.name ?? "") \(object.lastName ?? "")"
        if object.role == 0 {
            detailTextLabel?.text = Constants.student
        } else {
            detailTextLabel?.text = Constants.teacher
        }
        if let isSelect = isSelected {
            isPressed = isSelect
            accessoryView = UIImageView(
                image: isPressed ?
                    UIImage(named: Constants.bookmarkPressed) :
                    UIImage(named: Constants.bookmark)
            )
        }
        imageView?.image = image
    }
}
