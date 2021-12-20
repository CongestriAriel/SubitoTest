//
//  StyledButton.swift
//  Subito
//
//  Created by Ariel Congestri on 17/12/2021.
//

import UIKit

class StyledButton: UIButton {
    // MARK: - Definitions
    enum Style {
        case primary
        case secondary
    }

    enum Size: CGFloat {
        case regular = 50
    }
    // MARK: - Properties
    var style: Style

    // MARK: - Initializers
    init(style: Style, size: Size, frame: CGRect = .zero) {
        self.style = style
        super.init(frame: frame)
        configure(style, size)
        makeButtonAccessible()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Private Methods
private extension StyledButton {
    private func configure(_ style: Style, _ size: Size) {
        pin(.height, priority: .required - 1, relation: .greaterThanOrEqual, constant: size.rawValue)
        layer.cornerRadius = size.rawValue/2
        switch style {
        case .primary:
            configureForPrimaryStyle()
        case .secondary:
            configureForSecondaryStyle()
        }
    }

    func configureForPrimaryStyle() {
        backgroundColor = .primaryBlue
        setTitleColor(.white, for: .normal)
    }

    func configureForSecondaryStyle() {
        backgroundColor = .clear
        setTitleColor(.primaryBlue, for: .normal)
        layer.borderWidth = 3
        layer.borderColor = UIColor.primaryBlue.cgColor
    }

    func makeButtonAccessible() {
        titleLabel?.adjustsFontForContentSizeCategory = true
        titleLabel?.numberOfLines = 0
        titleLabel?.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel?.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel?.font = .preferredFont(forTextStyle: .body)
        titleLabel?.pin(
            .top,
            to: self,
            itemAttribute: .top,
            priority: .defaultHigh + 1,
            relation: .greaterThanOrEqual
        )
        .pin(
            .bottom,
            to: self,
            itemAttribute: .bottom,
            priority: .defaultHigh + 1,
            relation: .greaterThanOrEqual
        )
    }

}
