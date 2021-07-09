//
//  Student.swift
//  RealmLesson
//
//  Created by Roma Latynia on 5/8/21.
//

import Foundation

class User: Equatable {
    
    var id: String
    var name: String?
    var lastName: String?
    var eMail: String?
    var role: Int?
    var course: Course?
    var courseСonnection: [Course]?
    
    init(
        id: String = UUID().uuidString,
        name: String? = nil,
        lastName: String? = nil,
        eMail: String? = nil,
        role: Int? = nil,
        course: Course? = nil,
        courseСonnection: [Course]? = nil
    ) {
        self.id = id
        self.name = name
        self.lastName = lastName
        self.eMail = eMail
        self.role = role
        self.course = course
        self.courseСonnection = courseСonnection
    }
    
    static func == (value1: User, value2: User) -> Bool {
        value1.name == value2.name &&
            value1.lastName == value2.lastName &&
            value1.eMail == value2.eMail
    }
}
