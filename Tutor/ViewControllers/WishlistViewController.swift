//
//  WishlistViewController.swift
//  Tutor
//
//  Created by Eli Zhang on 11/24/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import Alamofire
import ViewAnimator

class WishlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
    var courses: [Course] = []
    var courseNames: [String] = []
    var filteredCourses: [Course] = []
    var filteredCourseNames: [String] = []
    var searchController: UISearchController!
    let courseWishlistReuseIdentifier = "courseWishlistReuseIdentifier"
    
    let cellHeight: CGFloat = 60
    let cellSpacingHeight: CGFloat = 10
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        NetworkManager.getAllCourses(completion: { courseList in
                                    self.courses = courseList
                                    for course in courseList {
                                        self.courseNames.append("\(course.course_subject) \(course.course_num): \(course.course_name)")
                                    }
                                    let rightFade = AnimationType.from(direction: .right, offset: 60.0)
                                    self.tableView.animate(animations: [rightFade], duration: 0.5)
                                    DispatchQueue.main.async {self.tableView.reloadData()}},
                                     failure: { () in self.courses = []})
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find a class"
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        tableView = UITableView()
        tableView.register(CourseWishlistTableViewCell.self, forCellReuseIdentifier: courseWishlistReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        let rightFade = AnimationType.from(direction: .right, offset: 60.0)
        tableView.animate(animations: [rightFade], duration: 0.5)
        view.addSubview(tableView)
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        tableView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view).offset(10)
            make.trailing.equalTo(view).offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering() {
            return filteredCourses.count
        }
        return courseNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: courseWishlistReuseIdentifier, for: indexPath) as! CourseWishlistTableViewCell
        let course: String
        if isFiltering() {
            course = filteredCourseNames[indexPath.section]
        } else {
            course = courseNames[indexPath.section]
        }
        cell.addInfo(course: course)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var courseAtIndex: Course
        if isFiltering() {
            courseAtIndex = filteredCourses[indexPath.section]
        } else {
            courseAtIndex = courses[indexPath.section]
        }
        let tutorTuteeCatalogViewController = TutorTuteeCatalogViewController(course: courseAtIndex)
        navigationController?.pushViewController(tutorTuteeCatalogViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCourseNames = courseNames.filter({( courseName: String) -> Bool in
            return courseName.lowercased().contains(searchText.lowercased())
        })
        filteredCourses = courses.filter({( course: Course ) -> Bool in
            return "\(course.course_subject) \(course.course_num): \(course.course_name)".lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension WishlistViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
