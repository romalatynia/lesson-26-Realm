//
//  Course.swift
//  RealmLesson
//
//  Created by Roma Latynia on 5/8/21.
//

import Foundation

class Course: Equatable {
    var idCourse: String
    var nameCourse: String?
    var subject: String?
    var branch: String?
    var owner: [User]?
    var ownerTeacher: [User]?
    
    init(
        idCourse: String = UUID().uuidString,
        nameCourse: String? = nil,
        subject: String? = nil,
        branch: String? = nil,
        owner: [User]? = nil,
        ownerTeacher: [User]? = nil
    ) {
        self.idCourse = idCourse
        self.nameCourse = nameCourse
        self.subject = subject
        self.branch = branch
        self.owner = owner
        self.ownerTeacher = ownerTeacher
    }
    
    static func == (value1: Course, value2: Course) -> Bool {
        value1.nameCourse == value2.nameCourse &&
            value1.subject == value2.subject &&
            value1.branch == value2.branch
    }
}
