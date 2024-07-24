//
//  MainVC.swift
//  TrailApp
//
//  Created by CharismaInfotainment on 12/05/23.
//

import UIKit

class MainVC: UIViewController {
    let label = UILabel()
    let moreButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.text = "Your text here"
        view.addSubview(label)
        
        // Set up more button
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.setTitle("More", for: .normal)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        view.addSubview(moreButton)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            moreButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            moreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func moreButtonTapped() {
        if label.numberOfLines == 0 {
            label.numberOfLines = 3
            moreButton.setTitle("More", for: .normal)
        } else {
            label.numberOfLines = 0
            moreButton.setTitle("Less", for: .normal)
        }
    }
}
