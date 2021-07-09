//
//  DBManager.swift
//  RealmLesson
//
//  Created by Roma Latynia on 5/19/21.
//

import Foundation
import RealmSwift

class DBManager {
    
    static let shared = DBManager()
    private var database = try! Realm()
    
    // MARK: - загрузка объкетов
    func getAllUsers(complection: @escaping ([User]) -> Void) {
        let userRLM = self.database.objects(UserRLM.self).sorted(byKeyPath: "role", ascending: true)
        let users = Array(userRLM.compactMap { $0.toModel() })
        complection(users)
    }
    
    func getAll() -> Results<UserRLM> {
        let userRLM = self.database.objects(UserRLM.self).sorted(byKeyPath: "role", ascending: true)
        return userRLM
    }
    
    func getAllStudents(role: Int, complection: @escaping ([User]) -> Void) {
        let userRLM = self.database.objects(UserRLM.self).filter("role == \(role)")
        let users = Array(userRLM.compactMap { $0.toModel() })
        complection(users)
    }
    
    func getAllCourses(complection: @escaping ([Course]) -> Void) {
        let courseRLM = self.database.objects(CourseRLM.self)
        let courses = Array(courseRLM.compactMap { $0.toModel() })
        complection(courses)
    }
    
    // MARK: - сохранение или добавление объкетов
    func saveUsers(users: [User]) {
        let users = users.compactMap { UserRLM(model: $0) }
        self.saveRealmArray(users)
    }
    
    func saveUser(user: User) {
        let userRLM = UserRLM(model: user)
        self.saveRealmObject(userRLM)
    }
    
    func saveCourses(courses: [Course]) {
        let courses = courses.compactMap { CourseRLM(model: $0) }
        self.saveRealmArray(courses)
    }
    
    func addCourse(course: Course) {
        self.saveRealmObject(CourseRLM(model: course))
    }
    
    func addCourseTeacher(teacher: User, course: Course) {
        let userDB = Array(database.objects(UserRLM.self))
        let courseDB = Array(database.objects(CourseRLM.self))
        if let teacher = userDB.first(where: { $0.id == teacher.id }),
           let course = courseDB.first(where: { $0.idCourse == course.idCourse }) {
            addRealmTeacherCourse(teacher: teacher, course: course)
        }
    }
    
    func addCourseStudent(student: User, course: Course) {
        let userDB = Array(database.objects(UserRLM.self))
        let courseDB = Array(database.objects(CourseRLM.self))
        if let student = userDB.first(where: { $0.id == student.id }),
           let course = courseDB.first(where: { $0.idCourse == course.idCourse }) {
            addRealmStudentCourse(student: student, course: course)
        }
    }
    
    // MARK: - удаление объкетов
    func deleteUser(user: User) {
        let userDB = Array(database.objects(UserRLM.self))
        if let user = userDB.first(where: { $0.id == user.id }) {
            deleteRealmObject(user)
        }
    }
    
    func deleteCourse(course: Course) {
        let courseDB = Array(database.objects(CourseRLM.self))
        if let course = courseDB.first(where: { $0.idCourse == course.idCourse }) {
            deleteRealmObject(course)
        }
    }
    
    func deleteCourseTeacher(teacher: User) {
        let userDB = Array(database.objects(UserRLM.self))
        if let teacher = userDB.first(where: { $0.id == teacher.id }) {
            deleteRealmTeacherCourse(teacher: teacher)
        }
    }
    
    func deleteCourseStudent(student: User, index: Int) {
        let userDB = Array(database.objects(UserRLM.self))
        if let student = userDB.first(where: { $0.id == student.id }) {
            deleteRealmStudetnCourse(student: student, index: index)
        }
    }
    
    // MARK: - редактирование объкетов
    func editUser(user: User, editUser: User) {
        let userDB = Array(database.objects(UserRLM.self))
        let editUserRLM = UserRLM(model: editUser)
        if let user = userDB.first(where: { $0.id == user.id }) {
            editRealmUser(user: user, editUserRLM: editUserRLM)
        }
    }
    
    func editCourse(course: Course, editCourse: Course) {
        let courseDB = Array(database.objects(CourseRLM.self))
        let editCourseRLM = CourseRLM(model: editCourse)
        if let course = courseDB.first(where: { $0.idCourse == course.idCourse }) {
            editRealmCourse(course: course, editCourseRLM: editCourseRLM)
        }
    }
}

// MARK: - Private funcs
private extension DBManager {
    func addRealmStudentCourse(student: UserRLM, course: CourseRLM) {
        do {
            try database.write {
                student.courseСonnection.append(course)
            }
        } catch {
            print("Add action failed: \(error)")
        }
    }
    
    func addRealmTeacherCourse(teacher: UserRLM, course: CourseRLM) {
        do {
            try database.write {
                teacher.course = course
            }
        } catch {
            print("Add action failed: \(error)")
        }
    }

    func saveRealmArray(_ objects: [Object]) {
        do {
            try database.write {
                database.add(objects, update: .modified)
            }
        } catch {
            print("Save action failed: \(error)")
        }
    }
    
    func saveRealmObject(_ object: Object) {
        do {
            try database.write {
                database.add(object, update: .modified)
            }
        } catch {
            print("Save action failed: \(error)")
        }
    }
    
    func editRealmUser(user: UserRLM, editUserRLM: UserRLM) {
        do {
            try database.write {
                user.name = editUserRLM.name
                user.lastName = editUserRLM.lastName
                user.eMail = editUserRLM.eMail
                user.role = editUserRLM.role
            }
        } catch {
            print("Edit action failed: \(error)")
        }
    }
    
    func editRealmCourse(course: CourseRLM, editCourseRLM: CourseRLM) {
        do {
            try database.write {
                course.nameCourse = editCourseRLM.nameCourse
                course.subject = editCourseRLM.subject
                course.branch = editCourseRLM.branch
            }
        } catch {
            print("Edit action failed: \(error)")
        }
    }
    
    func deleteRealmStudetnCourse(student: UserRLM, index: Int) {
        do {
            try database.write {
                student.courseСonnection.remove(at: index)
            }
        } catch {
            print("Delete action failed: \(error)")
        }
    }
    
    func deleteRealmTeacherCourse(teacher: UserRLM) {
        do {
            try database.write {
                teacher.course = nil
            }
        } catch {
            print("Delete action failed: \(error)")
        }
    }
    
    func deleteRealmObject(_ object: Object) {
        do {
            try database.write {
                database.delete(object)
            }
        } catch {
            print("Delete action failed: \(error)")
        }
    }
}
