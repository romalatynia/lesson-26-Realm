//
//  AddCourseTableCell.swift
//  RealmLesson
//
//  Created by Roma Latynia on 4/14/21.
//

import UIKit

private enum Constants {
    static let width: CGFloat = 36
    static let height: CGFloat = 18
    static let bordeWidth: CGFloat = 1
}

class TableViewCell: UITableViewCell {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    func setupView() {
        contentView.layer.borderWidth = Constants.bordeWidth
        contentView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
