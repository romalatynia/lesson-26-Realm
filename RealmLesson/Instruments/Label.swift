//
//  Label.swift
//  RealmLesson
//
//  Created by Roma Latynia on 4/13/21.
//

import UIKit

struct Label {
    static func makeLabel(title: String? = nil, textColor: UIColor = .black) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = title
        label.textColor = textColor
        return label
    }
}
