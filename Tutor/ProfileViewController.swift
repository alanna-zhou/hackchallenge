//
//  ProfileViewController.swift
//  Tutor
//
//  Created by Eli Zhang on 11/20/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import NotificationBannerSwift

class ProfileViewController: UIViewController, UITextFieldDelegate {

    var username: String!
    var name: String!
    var yearLabel: UILabel!
    var yearTextField: UITextField!
    var majorLabel: UILabel!
    var majorTextField: UITextField!
    var bioLabel: UILabel!
    var bio: UITextView!
    var submitButton: UIButton!
    
    let addUserURL = "http://localhost:5000/api/user/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)

        yearLabel = UILabel()
        yearLabel.text = "Year:"
        yearLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        view.addSubview(yearLabel)
        
        yearTextField = UITextField()
        yearTextField.placeholder = "Graduation year"
        yearTextField.delegate = self
        yearTextField.tag = 0
        view.addSubview(yearTextField)
        
        majorLabel = UILabel()
        majorLabel.text = "Major:"
        majorLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        view.addSubview(majorLabel)
        
        majorTextField = UITextField()
        majorTextField.placeholder = "Enter your major"
        majorTextField.delegate = self
        majorTextField.tag = 1
        view.addSubview(majorTextField)
        
        bioLabel = UILabel()
        bioLabel.text = "Bio:"
        bioLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        view.addSubview(bioLabel)
        
        bio = UITextView()
        bio.isEditable = true
        view.addSubview(bio)
        
        submitButton = UIButton()
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        submitButton.addTarget(self, action: #selector(validateProfile), for: .touchUpInside)
        view.addSubview(submitButton)
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        yearLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view).offset(20)
        }
        yearTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(yearLabel.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
        }
        majorLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(yearTextField.snp.bottom).offset(30)
            make.leading.equalTo(view).offset(20)
        }
        majorTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(majorLabel.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
        }
        bioLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(majorTextField.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
        }
        bio.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(bioLabel.snp.bottom).offset(20)
            make.height.equalTo(100)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(20)
            make.leading.equalTo(view).offset(20)
        }
        submitButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(bio.snp.bottom).offset(40)
            make.centerX.equalTo(view)
        }
        
    }
    
    @objc func validateProfile() {
        guard let year = yearTextField.text, year != "" else {
            let banner = NotificationBanner(title: "No year entered.", style: .danger)
            banner.show()
            return
        }
        guard let major = majorTextField.text, major != "" else {
            let banner = NotificationBanner(title: "No major entered.", style: .danger)
            banner.show()
            return
        }
        guard let bio = bio.text, bio != "" else {
            let banner = NotificationBanner(title: "No bio entered.", style: .danger)
            banner.show()
            return
        }
        let parameters: Parameters = ["net_id": username,
                                      "name": name,
                                      "year": year,
                                      "major": major,
                                      "bio": bio]
        Alamofire.request(addUserURL, parameters: parameters).validate().responseData { response in
            switch response.result {
            case let .success(data):
                let decoder = JSONDecoder()
                print("Successful response")
                if let username = try? decoder.decode(Username.self, from: data) {
                    if username.success {
                        let banner = NotificationBanner(title: "Successfully logged in!", style: .success)
                        banner.show()
                        self.dismiss(animated: true, completion: nil)
                        return
                    }
                    else {
                        let banner = NotificationBanner(title: "Username is already taken!", style: .danger)
                        banner.show()
                    }
                }
            case let .failure(error):
                print("Connection to server failed!")
                print(error.localizedDescription)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        bio.resignFirstResponder()
    }
}