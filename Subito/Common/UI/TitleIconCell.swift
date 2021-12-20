//
//  TitleImageCell.swift
//  Subito
//
//  Created by Ariel Congestri on 19/12/2021.
//

import UIKit
import Kingfisher

class TitleImageCell: UITableViewCell, StaticCell {
    // MARK: - ViewData
    struct ViewData {
        var title: String
        var imageURL: URL?
        var placeHolderImage: UIImage?
        var emptyImage: UIImage?
    }
    // MARK: - Properties
    private let minimumImageSize: CGFloat = 44
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        isAccessibilityElement = false
        label.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.isAccessibilityElement = false
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        isAccessibilityElement = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        return imageView
    }()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setUpConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func configure(with viewData: ViewData) {
        isAccessibilityElement = true
        accessibilityLabel = viewData.title
        titleLabel.text = viewData.title
        if let url = viewData.imageURL {
            iconImageView.kf.setImage(with: url, placeholder: viewData.placeHolderImage)
        } else {
            iconImageView.image = viewData.emptyImage
        }
    }
}
// MARK: - Private Methods
extension TitleImageCell {
    
    func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
    }

    func setUpConstraints() {
        titleLabel.pin(.top, to: contentView, itemAttribute: .top, constant: Spacing.small.rawValue)
            .pin(.bottom, to: contentView, itemAttribute: .bottom, constant: -Spacing.small.rawValue)
            .pin(.leading, to: contentView, itemAttribute: .leading, constant: Spacing.small.rawValue)
            .pin(.trailing, to: iconImageView, itemAttribute: .leading, constant: -Spacing.medium.rawValue)

        iconImageView.pin(.top, to: contentView, itemAttribute: .top, constant: Spacing.small.rawValue)
            .pin(.bottom, to: contentView, itemAttribute: .bottom, relation: .lessThanOrEqual, constant: -Spacing.small.rawValue)
            .pin(.height, constant: minimumImageSize)
            .pin(.width, constant: minimumImageSize)
            .pin(.trailing, to: contentView, itemAttribute: .trailing, constant: -Spacing.medium.rawValue)
    }
}
