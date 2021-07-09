//
//  Course.swift
//  RealmLesson
//
//  Created by Roma Latynia on 4/14/21.
//

import Foundation
import RealmSwift

@objcMembers
class CourseRLM: Object {
    
    dynamic var idCourse = UUID().uuidString
    dynamic var nameCourse = ""
    dynamic var subject = ""
    dynamic var branch = ""
    var owner = LinkingObjects(fromType: UserRLM.self, property: "courseСonnection")
    var ownerTeacher = LinkingObjects(fromType: UserRLM.self, property: "course")
    
    required init() {
        super.init()
    }
    
    convenience init(model: Course) {
        self.init()
        self.idCourse = model.idCourse
        self.nameCourse = model.nameCourse ?? ""
        self.subject = model.subject ?? ""
        self.branch = model.branch ?? ""
        self.owner = owner
        self.ownerTeacher = ownerTeacher
    }
    
    override class func primaryKey() -> String? {
         "idCourse"
    }
    
    func toModel() -> Course {
        let newOwnerTeacher = Array(ownerTeacher).compactMap {
            User(
                id: $0.id,
                name: $0.name,
                lastName: $0.lastName,
                eMail: $0.eMail,
                role: $0.role
            )
        }
        let newOwner = Array(owner).compactMap {
            User(
                id: $0.id,
                name: $0.name,
                lastName: $0.lastName,
                eMail: $0.eMail,
                role: $0.role
            )
        }
        return Course(
            idCourse: idCourse,
            nameCourse: nameCourse,
            subject: subject,
            branch: branch,
            owner: newOwner,
            ownerTeacher: newOwnerTeacher
        )
    }
}
