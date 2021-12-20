//
//  UIView+Extensions.swift
//  Subito
//
//  Created by Ariel Congestri on 17/12/2021.
//

import UIKit

extension UIView {
    // MARK: - Editing
    @objc func finishEditing() {
        subviews.forEach {
            if $0.isFirstResponder {
                $0.resignFirstResponder()
            } else {
                $0.finishEditing()
            }
        }
    }

    // MARK: - Constraints
    func pinEdges(to view: Any?) {
        pin( .top, to: view, itemAttribute: .top)
            .pin( .bottom, to: view, itemAttribute: .bottom)
            .pin( .trailing, to: view, itemAttribute: .trailing)
            .pin( .leading, to: view, itemAttribute: .leading)
    }

    @discardableResult
    func pin(_ attribute: NSLayoutConstraint.Attribute,
             to item: Any? = nil,
             itemAttribute: NSLayoutConstraint.Attribute = .notAnAttribute,
             multiplier: CGFloat = 1.0,
             priority: UILayoutPriority = .required,
             relation: NSLayoutConstraint.Relation = .equal,
             constant: CGFloat = 0
        ) -> UIView {

        translatesAutoresizingMaskIntoConstraints = false

        let constraint = NSLayoutConstraint(
            item: self,
            attribute: attribute,
            relatedBy: relation,
            toItem: item,
            attribute: itemAttribute,
            multiplier: multiplier,
            constant: constant
        )
        constraint.priority = priority
        constraint.isActive = true

        return self
    }
}
