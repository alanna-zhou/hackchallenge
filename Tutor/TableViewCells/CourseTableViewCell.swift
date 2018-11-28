//
//  CourseTableViewCell.swift
//  Tutor
//
//  Created by Eli Zhang on 11/24/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class CourseTableViewCell: UITableViewCell {

    var courseLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        courseLabel = UILabel()
        courseLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        contentView.addSubview(courseLabel)
    }
    
    override func updateConstraints() {
        courseLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView).offset(20)
            make.trailing.equalTo(contentView).offset(-20)
        }
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addInfo(course: Course) {
        courseLabel.text = "\(course.course_subject) \(course.course_num): \(course.course_name)"
    }
}
