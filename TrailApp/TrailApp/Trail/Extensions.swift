//
//  Extensions.swift
//  TrailApp
//
//  Created by CharismaInfotainment on 12/05/23.
//
//
import UIKit

extension UIImageView {
    func load(with url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIView {
    func anchors(
        top: NSLayoutYAxisAnchor? = nil,
        topConstant: CGFloat = 0,
        leading: NSLayoutXAxisAnchor? = nil,
        leadingConstant: CGFloat = 0,
        bottom: NSLayoutYAxisAnchor? = nil,
        bottomConstant: CGFloat = 0,
        trailing: NSLayoutXAxisAnchor? = nil,
        trailingConstant: CGFloat = 0,
        centerX: NSLayoutXAxisAnchor? = nil,
        centerY: NSLayoutYAxisAnchor? = nil,
        width: NSLayoutDimension? = nil,
        widthConstant: CGFloat = 0,
        height: NSLayoutDimension? = nil,
        heightConstant: CGFloat = 0
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: leadingConstant).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -trailingConstant).isActive = true
        }
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalTo: width, constant: widthConstant).isActive = true
        } else if widthConstant != 0 {
            widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalTo: height, constant: heightConstant).isActive = true
        } else if heightConstant != 0 {
            heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        }
    }

    
    func addSubviews(_ views:UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views:UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
