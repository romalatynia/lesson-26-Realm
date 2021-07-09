//
//  Contact.swift
//  RealmLesson
//
//  Created by Roma Latynia on 4/6/21.
//

import Foundation
import RealmSwift

@objcMembers
class UserRLM: Object {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var lastName = ""
    dynamic var eMail = ""
    dynamic var role = Int()
    dynamic var course: CourseRLM?
    var courseСonnection = List<CourseRLM>()
    
    required init() {
        super.init()
    }
    
    convenience init(model: User) {
        self.init()
        self.id = model.id
        self.name = model.name ?? ""
        self.lastName = model.lastName ?? ""
        self.eMail = model.eMail ?? ""
        self.role = model.role ?? Int()
        if let course = model.course {
            self.course = CourseRLM(model: course)
        }
        model.courseСonnection?.forEach {
            self.courseСonnection.append(CourseRLM(model: $0))
        }
    }
    
    override class func primaryKey() -> String? {
         "id"
    }
    
    static func == (value1: UserRLM, value2: UserRLM) -> Bool {
        value1.name == value2.name &&
            value1.lastName == value2.lastName &&
            value1.eMail == value2.eMail
    }
    
    func toModel() -> User {
        User(
            id: id,
            name: name,
            lastName: lastName,
            eMail: eMail,
            role: role,
            course: course?.toModel(),
            courseСonnection: courseСonnection.compactMap { $0.toModel() }
        )
    }
}
