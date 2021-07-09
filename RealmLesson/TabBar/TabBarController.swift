//
//  TabBarController.swift
//  RealmLesson
//
//  Created by Roma Latynia on 4/14/21.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let user = UserViewController()
        user.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        
        let course = CourseTable()
        course.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        
        let teacher = TeacherTableVC()
        teacher.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        
        let defaultControllers: [UIViewController] = [user, course, teacher]
        
        let navControllers = defaultControllers.map {
            UINavigationController(rootViewController: $0)
        }
        setViewControllers(navControllers, animated: true)
    }
}
