//
//  StaticCell.swift
//  Subito
//
//  Created by Ariel Congestri on 17/12/2021.
//

import UIKit

protocol StaticCell: UITableViewCell {
    associatedtype ViewData
    func configure(with viewData: ViewData)
}
