//
//  KeyboardDismissable.swift
//  Subito
//
//  Created by Ariel Congestri on 17/12/2021.
//

import UIKit

protocol KeyboardDismissable: UIViewController {
    func dismissKeyboardOnTouchUpOutside()
}
extension KeyboardDismissable {
    func dismissKeyboardOnTouchUpOutside() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(view.finishEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
